//
//  FavoriteViewModel.swift
//  UPosts
//
//  Created by Sanjeev Mishra on 28/08/24.
//

import Foundation
import RxSwift
import RxCocoa
import CoreData

final class FavoriteViewModel: NSObject {
    private var _favorites = BehaviorSubject(value: [PostDTO]())
    var favorites: Observable<[PostDTO]> {
        _favorites.asObservable()
    }
    private let disposeBag = DisposeBag()
    private let fetchedResultsController: FetchedResultsControllerProtocol
    private let coreDataManager: FavoriteCDManagerProtocol
    
    // Dependency injection via initializer
    init(coreDataManager: FavoriteCDManagerProtocol = CoreDataManager.shared,
         fetchedResultsController: FetchedResultsControllerProtocol) {
        
        self.coreDataManager = coreDataManager
        self.fetchedResultsController = fetchedResultsController
        
        super.init()
        
        // Set the delegate
        self.fetchedResultsController.delegate = self
        
        // Perform the fetch
        do {
            try self.fetchedResultsController.performFetch()
            // Initialize the BehaviorSubject with fetched results
            let postDTOs = transformPostsToPostDTOs(self.fetchedResultsController.fetchedObjects ?? [])
            _favorites.onNext(postDTOs)
        } catch {
            print("Failed to fetch initial data: \(error)")
        }
    }
    
    // Fetch favorite post from local database
    private func fetchLocalFavoritePosts() -> Observable<[PostDTO]> {
        return Observable.create { observer in
            let posts = self.coreDataManager.fetchAllFavoritePosts()
            observer.onNext(posts)
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    // Transform Post entities to PostDTO
    private func transformPostsToPostDTOs(_ posts: [Post]) -> [PostDTO] {
        return posts.map { post in
            return PostDTO(
                userId: Int(post.userId),
                id: Int(post.id),
                title: post.title ?? "",
                body: post.body ?? "",
                isFavorite: post.isFavorite
            )
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension FavoriteViewModel: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newPost = anObject as? Post {
                var currentPostsDTOs = (try? _favorites.value()) ?? []
                let newPostDTO = transformPostsToPostDTOs([newPost]).first!
                currentPostsDTOs.append(newPostDTO)
                _favorites.onNext(currentPostsDTOs)
            }
        case .delete:
            if let _ = indexPath, let deletedPost = anObject as? Post {
                var currentPostsDTOs = (try? _favorites.value()) ?? []
                let deletedPostDTOs = transformPostsToPostDTOs([deletedPost])
                currentPostsDTOs.removeAll { deletedPostDTOs.contains($0) }
                _favorites.onNext(currentPostsDTOs)
            }
        case .update:
            // Handle updates
            let updatedPostsDTOs = transformPostsToPostDTOs(fetchedResultsController.fetchedObjects ?? [])
            _favorites.onNext(updatedPostsDTOs)
        case .move:
            // Handle moves if needed
            break
        @unknown default:
            fatalError("Unhandled change type")
        }
    }
}

//
//  PostViewModel.swift
//  UPosts
//
//  Created by Sanjeev Mishra on 28/08/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PostViewModel {
    // Observable for the navigation title
    let navigationTitle = BehaviorSubject<String>(value: "Posts")
    let postsSubject = BehaviorSubject(value: [Post]())
    private let favoritedPosts = BehaviorSubject<Set<String>>(value: Set())
    private let networkService = NetworkService()
    private let disposeBag = DisposeBag()
    
    // Fethcing post from API/local database according the condition
    func fetchPosts() {
        if NetworkReachability.shared.isNetworkReachable() {
            networkService.fetchPostsFromAPI()
                .subscribe { [weak self] event in
                    switch event {
                    case .success(let posts):
                        let savedPosts = CoreDataManager.shared.fetchAllPosts()
                        if savedPosts.isEmpty {
                            CoreDataManager.shared.savePosts(posts: posts, completion: {_ in })
                        }
                        self?.postsSubject.onNext(savedPosts.isEmpty ? posts : savedPosts)
                    case .failure(let error):
                        print("Error fetching posts: \(error)")
                    }
                }
                .disposed(by: disposeBag)
        } else {
            fetchLocalPosts()
                .subscribe(onNext: { [weak self] posts in
                    self?.postsSubject.onNext(posts)
                }, onError: { error in
                    print("Failed to fetch posts: \(error)")
                })
                .disposed(by: disposeBag)
        }
    }
    
    // Handle post row click
    func handleCellClick(_ selectedPost: Post) {
        // Get the current posts from the postsSubject
        postsSubject
            .take(1) // Take the first emitted value (current value)
            .subscribe(onNext: { [weak self] posts in
                // Find the index of the selected post
                guard let index = posts.firstIndex(where: { $0.id == selectedPost.id }) else { return }
                
                // Create an updated post with the 'isFavorite' flag toggled
                var updatedPosts = posts
                updatedPosts[index].isFavorite.toggle() // Toggle the isFavorited property
                                
                CoreDataManager.shared.updatePostToFavorite(isFavorite: updatedPosts[index].isFavorite, post: selectedPost)
                // Emit the updated list to postsSubject
                self?.postsSubject.onNext(updatedPosts)
            })
            .disposed(by: disposeBag)
    }
    
    // Get post from local database
    func fetchLocalPosts() -> Observable<[Post]> {
        return Observable.create { observer in
            let posts = CoreDataManager.shared.fetchAllPosts()
            observer.onNext(posts)
            observer.onCompleted()
            return Disposables.create()
        }
    }
}

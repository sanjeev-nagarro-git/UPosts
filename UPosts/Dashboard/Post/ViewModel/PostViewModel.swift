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
    private var _postsSubject = BehaviorSubject(value: [PostDTO]())
    var postsSubject: Observable<[PostDTO]> {
        _postsSubject.asObservable()
    }
    
    private let networkService: NetworkServiceProtocol
    private let coreDataManager: CoreDataManagerProtocol
    private let disposeBag = DisposeBag()
    
    // Dependency injection via initializer
    init(networkService: NetworkServiceProtocol = PostService(), coreDataManager: CoreDataManagerProtocol = CoreDataManager.shared) {
        self.networkService = networkService
        self.coreDataManager = coreDataManager
        
        // Initialize _postsSubject with initial posts from CoreDataManager
        let initialPosts = coreDataManager.fetchAllPosts()
        _postsSubject = BehaviorSubject(value: initialPosts)
    }
    
    // Fetching posts from API/local database according to the condition
    func fetchPosts() {
        if NetworkReachability.isNetworkReachable() {
            networkService.fetchPostsFromAPI()
                .subscribe { [weak self] event in
                    switch event {
                    case .success(let posts):
                        let savedPosts = self?.coreDataManager.fetchAllPosts() ?? []
                        if savedPosts.isEmpty {
                            self?.coreDataManager.savePosts(posts: posts, completion: {_ in })
                        }
                        let sortedPosts = posts.sorted { $0.title<$1.title }
                        self?._postsSubject.onNext(savedPosts.isEmpty ? sortedPosts : savedPosts)
                    case .failure(let error):
                        print("Error fetching posts: \(error)")
                    }
                }
                .disposed(by: disposeBag)
        } else {
            fetchLocalPosts()
                .subscribe(onNext: { [weak self] posts in
                    self?._postsSubject.onNext(posts)
                }, onError: { error in
                    print("Failed to fetch posts: \(error)")
                })
                .disposed(by: disposeBag)
        }
    }
    
    // Handle post row click
    func handleCellClick(_ selectedPost: PostDTO) {
        _postsSubject
            .take(1)
            .subscribe(onNext: { [weak self] posts in
                guard let index = posts.firstIndex(where: { $0.id == selectedPost.id }) else { return }
                
                var updatedPosts = posts
                updatedPosts[index].isFavorite.toggle()
                
                self?.coreDataManager.updatePostToFavorite(isFavorite: updatedPosts[index].isFavorite, post: selectedPost)
                self?._postsSubject.onNext(updatedPosts)
            })
            .disposed(by: disposeBag)
    }
    
    // Get posts from local database
    func fetchLocalPosts() -> Observable<[PostDTO]> {
        return Observable.create { observer in
            let posts = self.coreDataManager.fetchAllPosts()
            observer.onNext(posts)
            observer.onCompleted()
            return Disposables.create()
        }
    }
}

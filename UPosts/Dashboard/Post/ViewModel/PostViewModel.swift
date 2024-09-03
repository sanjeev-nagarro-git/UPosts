//
//  PostViewModel.swift
//  UPosts
//
//  Created by Sanjeev Mishra on 28/08/24.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

final class PostViewModel {
    private var _postsSubject = BehaviorSubject(value: [PostDTO]())
    var postsSubject: Observable<[PostDTO]> {
        _postsSubject.asObservable()
    }
    
    private let networkService: NetworkServiceProtocol
    private let disposeBag = DisposeBag()
    private let realmService: RealmPostServiceProtocol
    
    // Dependency injection via initializer
    init(networkService: NetworkServiceProtocol = PostService(), 
         realmService: RealmPostServiceProtocol = RealmServiceManager()) {
        self.networkService = networkService
        self.realmService = realmService
    }
    
    // Fetching posts from API/local database according to the condition
    func fetchPosts() {
        if NetworkReachability.isNetworkReachable() {
            networkService.fetchPostsFromAPI()
                .subscribe { [weak self] event in
                    switch event {
                    case .success(let posts):
                        let savedPosts = self?.realmService.fetchPosts() ?? []
                        if savedPosts.isEmpty {
                            self?.realmService.savePosts(posts, completion: { _ in })
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
                self?.realmService.updatePostFavoriteStatus(postId: selectedPost.id, isFavorite: !selectedPost.isFavorite)
                self?._postsSubject.onNext(updatedPosts)
            })
            .disposed(by: disposeBag)
    }
    
    // Get posts from local database
    func fetchLocalPosts() -> Observable<[PostDTO]> {
        return Observable.create { observer in
            let posts = self.realmService.fetchPosts()
            observer.onNext(posts)
            observer.onCompleted()
            return Disposables.create()
        }
    }
}

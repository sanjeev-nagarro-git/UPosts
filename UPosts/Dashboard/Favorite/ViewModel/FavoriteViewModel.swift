//
//  FavoriteViewModel.swift
//  UPosts
//
//  Created by Sanjeev Mishra on 28/08/24.
//

import Foundation
import RxSwift
import RxCocoa

class FavoriteViewModel {
    let navigationTitle = BehaviorSubject<String>(value: "Favorites")
    var favorites = BehaviorSubject(value: [Post]())
    private let disposeBag = DisposeBag()
    
    // Get favorite list
    func getFavoritePosts() {
        fetchLocalFavoritePosts()
            .subscribe(onNext: { [weak self] posts in
                self?.favorites.onNext(posts)
            }, onError: { error in
                print("Failed to fetch posts: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    // Fetch favorite post from local database
    func fetchLocalFavoritePosts() -> Observable<[Post]> {
        return Observable.create { observer in
            let posts = CoreDataManager.shared.fetchAllFavoritePosts()
            observer.onNext(posts)
            observer.onCompleted()
            return Disposables.create()
        }
    }
}

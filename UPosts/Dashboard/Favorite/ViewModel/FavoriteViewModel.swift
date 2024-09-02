//
//  FavoriteViewModel.swift
//  UPosts
//
//  Created by Sanjeev Mishra on 28/08/24.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

final class FavoriteViewModel: NSObject {
    private var _favorites = BehaviorSubject(value: [PostDTO]())
    var favorites: Observable<[PostDTO]> {
        _favorites.asObservable()
    }
    private let disposeBag = DisposeBag()
    private var notificationToken: NotificationToken?
    private let realmService: RealmFavoriteServiceProtocol
    
    init(realmService: RealmFavoriteServiceProtocol = RealmServiceManager()) {
        self.realmService = realmService
        super.init()
        observeFavorites()
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    func observeFavorites() {
        notificationToken = realmService.observeFavoritePosts { [weak self] result in
            switch result {
            case .success(let postDTOs):
                self?._favorites.onNext(postDTOs)
            case .failure(let error):
                print("Error observing favorites: \(error)")
            }
        }
    }
}

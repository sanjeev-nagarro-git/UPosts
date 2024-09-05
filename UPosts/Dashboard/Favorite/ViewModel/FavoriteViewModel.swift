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
        realmService.observeFavoritePosts()
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .background)) // Observe on background thread
            .subscribe(on: MainScheduler.instance) // Update on main thread
            .subscribe(onNext: { [weak self] postDTOs in
                guard let self = self else { return }
                self._favorites.onNext(postDTOs)
            }, onError: { error in
                print("Error observing favorites: \(error)")
            })
            .disposed(by: disposeBag)
    }
}

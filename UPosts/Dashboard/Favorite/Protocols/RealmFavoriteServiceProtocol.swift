//
//  RealmFavoriteServiceProtocol.swift
//  UPosts
//
//  Created by Sanjeev Mishra on 02/09/24.
//

import RxSwift

protocol RealmFavoriteServiceProtocol {
    func observeFavoritePosts() -> Observable<[PostDTO]>
}

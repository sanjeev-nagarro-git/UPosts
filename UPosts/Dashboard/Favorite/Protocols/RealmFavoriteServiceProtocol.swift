//
//  RealmFavoriteServiceProtocol.swift
//  UPosts
//
//  Created by Sanjeev Mishra on 02/09/24.
//

import RealmSwift

protocol RealmFavoriteServiceProtocol {
    func observeFavoritePosts(completion: @escaping (Result<[PostDTO], Error>) -> Void) -> NotificationToken?
}

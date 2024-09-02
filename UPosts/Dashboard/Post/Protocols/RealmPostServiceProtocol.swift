//
//  RealmPostServiceProtocol.swift
//  UPosts
//
//  Created by Sanjeev Mishra on 02/09/24.
//

protocol RealmPostServiceProtocol {
    func fetchPosts() -> [PostDTO]
    func savePosts(_ posts: [PostDTO], completion: @escaping (Bool) -> Void)
    func updatePostFavoriteStatus(postId: Int, isFavorite: Bool)
}

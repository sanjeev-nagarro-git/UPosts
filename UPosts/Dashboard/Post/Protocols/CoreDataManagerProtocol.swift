//
//  CoreDataManagerProtocol.swift
//  UPosts
//
//  Created by Sanjeev Mishra on 30/08/24.
//

protocol CoreDataManagerProtocol {
    func fetchAllPosts() -> [PostDTO]
    func savePosts(posts: [PostDTO], completion: @escaping (Bool) -> Void)
    func updatePostToFavorite(isFavorite: Bool, post: PostDTO)
}

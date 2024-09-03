//
//  RealmServiceManager.swift
//  UPosts
//
//  Created by Sanjeev Mishra on 02/09/24.
//

import RealmSwift

class RealmServiceManager {
    private var realm: Realm
    
    init() {
        realm = try! Realm()
    }
}

extension RealmServiceManager: RealmPostServiceProtocol {
    func fetchPosts() -> [PostDTO] {
        let storedPosts = realm.objects(Post.self).sorted(byKeyPath: "title", ascending: true)
        
        return storedPosts.map { PostDTO(userId: $0.userId, id: $0.id, title: $0.title, body: $0.body, isFavorite: $0.isFavorite) }
    }
    
    func savePosts(_ posts: [PostDTO], completion: @escaping (Bool) -> Void) {
        // Convert PostDTO to Post
        let storedPosts = posts.map { Post(from: $0) }

        do {
            try realm.write {
                realm.add(storedPosts, update: .modified)
            }
        } catch {
            print("Error writing to Realm: \(error)")
        }
    }
    
    func updatePostFavoriteStatus(postId: Int, isFavorite: Bool) {
        // Find the post with the specified ID
        if let storedPost = realm.object(ofType: Post.self, forPrimaryKey: postId) {
            // Perform the write transaction to update the `isFavorite` property
            do {
                try realm.write {
                    storedPost.isFavorite = isFavorite
                    print("Successfully wrote to Realm")
                }
            } catch {
                print("Error writing to Realm: \(error)")
            }
        } else {
            print("Post with ID \(postId) not found.")
        }
    }
}

extension RealmServiceManager: RealmFavoriteServiceProtocol {
    func observeFavoritePosts(completion: @escaping (Result<[PostDTO], any Error>) -> Void) -> RealmSwift.NotificationToken? {
        let favoritePosts = realm.objects(Post.self).filter("isFavorite == true")
        
        return favoritePosts.observe { changes in
            switch changes {
            case .initial(let posts), .update(let posts, _, _, _):
                let postDTOs = posts.map { PostDTO(userId: $0.userId, id: $0.id, title: $0.title, body: $0.body, isFavorite: $0.isFavorite) }
                completion(.success(Array(postDTOs)))
            case .error(let error):
                completion(.failure(error))
            }
        }
    }
}

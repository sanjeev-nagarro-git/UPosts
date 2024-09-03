//
//  Post.swift
//  UPosts
//
//  Created by Sanjeev Mishra on 02/09/24.
//

import RealmSwift

class Post: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var userId: Int
    @Persisted var title: String
    @Persisted var body: String
    @Persisted var isFavorite = false
}

extension Post {
    convenience init(from dto: PostDTO) {
        self.init()
        self.userId = dto.userId
        self.id = dto.id
        self.title = dto.title
        self.body = dto.body
        self.isFavorite = dto.isFavorite
    }
}

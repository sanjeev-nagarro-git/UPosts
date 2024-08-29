//
//  Post.swift
//  UPosts
//
//  Created by Sanjeev Mishra on 28/08/24.
//

import Foundation

// Post we are using in app
struct Post: Equatable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
    var isFavorite = false
    
    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id
    }
}

// Model getting from API response
struct PostResponse: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

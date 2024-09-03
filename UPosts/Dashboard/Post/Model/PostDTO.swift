//
//  PostDTO.swift
//  UPosts
//
//  Created by Sanjeev Mishra on 02/09/24.
//

import Foundation


// Post we are using in app
struct PostDTO: Equatable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
    var isFavorite = false
    
    static func == (lhs: PostDTO, rhs: PostDTO) -> Bool {
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

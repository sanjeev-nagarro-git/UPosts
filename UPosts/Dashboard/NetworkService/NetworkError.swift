//
//  NetworkError.swift
//  UPosts
//
//  Created by Sanjeev Mishra on 01/09/24.
//

enum NetworkError: Error {
    case invalidResponse
    case decodingError
    case networkError(Error)
}

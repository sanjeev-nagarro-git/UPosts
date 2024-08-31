//
//  NetworkServiceProtocol.swift
//  UPosts
//
//  Created by Sanjeev Mishra on 30/08/24.
//

import RxSwift

protocol NetworkServiceProtocol {
    func fetchPostsFromAPI() -> Single<[PostDTO]>
}

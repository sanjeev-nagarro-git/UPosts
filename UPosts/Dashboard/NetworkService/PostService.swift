//
//  PostService.swift
//  UPosts
//
//  Created by Sanjeev Mishra on 01/09/24.
//

import RxSwift
import RxCocoa
import Alamofire
import Foundation

class PostService: NetworkService, NetworkServiceProtocol {
    // Fetch posts from API
    func fetchPostsFromAPI() -> Single<[PostDTO]> {
        let url = "\(baseURL)/posts"
        
        return Single.create { single in
            AF.request(url, method: .get)
                .validate()
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        do {
                            let response = try JSONDecoder().decode([PostResponse].self, from: data)
                            let posts = response.map { PostDTO(userId: $0.userId, id: $0.id, title: $0.title, body: $0.body) }
                            single(.success(posts))
                        } catch {
                            single(.failure(NetworkError.decodingError))
                        }
                    case .failure(let error):
                        single(.failure(NetworkError.networkError(error)))
                    }
                }
            return Disposables.create()
        }
        .timeout(.seconds(10), scheduler: MainScheduler.instance) // Set a timeout
        .retry(3)
    }
}

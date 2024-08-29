//
//  NetworkService.swift
//  UPosts
//
//  Created by Sanjeev Mishra on 29/08/24.
//

import RxSwift
import RxCocoa
import Alamofire
import Foundation

class NetworkService {
    
    private let baseURL = "https://jsonplaceholder.typicode.com"
    
    // Fetch posts from API
    func fetchPosts() -> Observable<[Post]> {
        let url = "\(baseURL)/posts"
        
        return Observable.create { observer in
            AF.request(url, method: .get)
                .validate()
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        do {
                            let response = try JSONDecoder().decode([PostResponse].self, from: data)
                            let posts = response.map { Post(userId: $0.userId, id: $0.id, title: $0.title, body: $0.body) }
                            let savedPosts = CoreDataManager.shared.fetchAllPosts()
                            if savedPosts.isEmpty {
                                CoreDataManager.shared.savePosts(posts: posts, completion: {_ in })
                            }
                            observer.onNext(savedPosts.isEmpty ? posts : savedPosts)
                            observer.onCompleted()
                        } catch {
                            observer.onError(error)
                        }
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
}

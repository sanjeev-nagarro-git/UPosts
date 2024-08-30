//
//  NetworkReachability.swift
//  UPosts
//
//  Created by Sanjeev Mishra on 30/08/24.
//

import Foundation
import Alamofire

final class NetworkReachability {
    
    static let shared = NetworkReachability()
    
    private let reachabilityManager = NetworkReachabilityManager()
    
    private init() {}
    
    // Checking network is available or not
    func isNetworkReachable() -> Bool {
        return reachabilityManager?.isReachable ?? false
    }
}

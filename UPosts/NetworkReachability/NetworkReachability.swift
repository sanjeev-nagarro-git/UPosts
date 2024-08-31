//
//  NetworkReachability.swift
//  UPosts
//
//  Created by Sanjeev Mishra on 30/08/24.
//

import Foundation
import Alamofire

enum NetworkReachability {
    static func isNetworkReachable() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}

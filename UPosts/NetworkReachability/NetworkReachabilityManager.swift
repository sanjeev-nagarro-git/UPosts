//
//  NetworkReachabilityManager.swift
//  UPosts
//
//  Created by Sanjeev Mishra on 29/08/24.
//

import Foundation
import Alamofire

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let reachabilityManager = NetworkReachabilityManager()
    
    private init() {
        
        // Start monitoring the network reachability status
        startNetworkReachabilityObserver()
    }
    
    func startNetworkReachabilityObserver() {
        reachabilityManager?.startListening { status in
            switch status {
            case .notReachable:
                print("No network connection.")
            case .reachable(.ethernetOrWiFi):
                print("Connected via WiFi.")
            case .reachable(.cellular):
                print("Connected via Cellular.")
            case .unknown:
                print("Network status is unknown.")
            }
        }
    }
    
    // Checking network is available or not
    func isNetworkReachable() -> Bool {
        return reachabilityManager?.isReachable ?? false
    }
}

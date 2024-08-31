//
//  LoginValidationProtocol.swift
//  UPosts
//
//  Created by Sanjeev Mishra on 30/08/24.
//

// Define a protocol for validation
protocol LoginValidationProtocol {
    static func isValidEmail(_ email: String) -> Bool
    static func isValidPassword(_ password: String) -> Bool
}

//
//  LoginValidation.swift
//  UPosts
//
//  Created by Sanjeev Mishra on 30/08/24.
//

import Foundation

// Implement the LoginValidationProtocol
class LoginValidation: LoginValidationProtocol {
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegex = Constants.Login.emailRegex
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    static func isValidPassword(_ password: String) -> Bool {
        return password.count >= 8 && password.count <= 15
    }
}

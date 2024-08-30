//
//  LoginViewModel.swift
//  UPosts
//
//  Created by Sanjeev Mishra on 28/08/24.
//

import Foundation
import RxSwift
import RxCocoa

final class LoginViewModel {
    // Inputs
    let email = BehaviorSubject<String>(value: "")
    let password = BehaviorSubject<String>(value: "")
    
    // Output
    let isSubmitButtonEnabled: Observable<Bool>
    // Combine email and password into a single LoginModel
    private var loginModel: Observable<LoginModel> {
        return Observable.combineLatest(email, password)
            .map { email, password in
                LoginModel(email: email, password: password)
            }
    }
    
    // Output
    var loginModelObservable: Observable<LoginModel> {
        return loginModel.asObservable()
    }
    
    private let disposeBag = DisposeBag()
    
    init() {
        isSubmitButtonEnabled = Observable.combineLatest(email, password)
            .map { email, password in
                return LoginViewModel.isValidEmail(email) && LoginViewModel.isValidPassword(password)
            }
    }
    
    // Validate email entered by user
    private static func isValidEmail(_ email: String) -> Bool {
        // Simple email validation regex
        let emailRegex = Constants.Login.emailRegex
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    // Validate password length
    private static func isValidPassword(_ password: String) -> Bool {
        return password.count >= 8 && password.count <= 15
    }
}


//
//  LoginViewModel.swift
//  UPosts
//
//  Created by Sanjeev Mishra on 28/08/24.
//

import Foundation
import RxSwift
import RxCocoa
// Implement the LoginViewModelProtocol
final class LoginViewModel: LoginViewModelProtocol {
    // Inputs
    let email = BehaviorSubject<String>(value: "")
    let password = BehaviorSubject<String>(value: "")
    
    // Output
    let isSubmitButtonEnabled: Observable<Bool>
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
    private let validator: LoginValidationProtocol.Type
    
    // Dependency injection via initializer
    init(validator: LoginValidationProtocol.Type = LoginValidation.self) {
        self.validator = validator
        isSubmitButtonEnabled = Observable.combineLatest(email, password)
            .map { email, password in
                return validator.isValidEmail(email) && validator.isValidPassword(password)
            }
    }
}

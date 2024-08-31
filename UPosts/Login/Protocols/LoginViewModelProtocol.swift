//
//  LoginViewModelProtocol.swift
//  UPosts
//
//  Created by Sanjeev Mishra on 30/08/24.
//

import RxSwift

// Define a protocol for the LoginViewModel
protocol LoginViewModelProtocol {
    var email: BehaviorSubject<String> { get }
    var password: BehaviorSubject<String> { get }
    var isSubmitButtonEnabled: Observable<Bool> { get }
    var loginModelObservable: Observable<LoginModel> { get }
}

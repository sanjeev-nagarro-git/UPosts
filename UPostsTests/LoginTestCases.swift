//
//  LoginTestCases.swift
//  UPosts
//
//  Created by Sanjeev Mishra on 30/08/24.
//

@testable import UPosts
import XCTest
import RxSwift
import RxCocoa

final class LoginValidationTests: XCTestCase {

    func testValidEmail() {
        XCTAssertTrue(LoginValidation.isValidEmail("test@example.com"))
        XCTAssertFalse(LoginValidation.isValidEmail("invalid-email"))
    }

    func testValidPassword() {
        XCTAssertTrue(LoginValidation.isValidPassword("password123"))
        XCTAssertFalse(LoginValidation.isValidPassword("short"))
        XCTAssertFalse(LoginValidation.isValidPassword("thispasswordiswaytoolong"))
    }
}

final class LoginViewModelTests: XCTestCase {

    var viewModel: LoginViewModel!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        viewModel = LoginViewModel()
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        viewModel = nil
        disposeBag = nil
        super.tearDown()
    }

    func testEmailAndPasswordValidation() {
        viewModel.email.onNext("test@example.com")
        viewModel.password.onNext("password123")
        
        let expectation = self.expectation(description: "isSubmitButtonEnabled should be true")
        
        viewModel.isSubmitButtonEnabled
            .subscribe(onNext: { isEnabled in
                if isEnabled {
                    expectation.fulfill()
                }
            })
            .disposed(by: disposeBag)
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }

    func testLoginModelObservable() {
        let expectation = self.expectation(description: "loginModelObservable should emit LoginModel")
        
        viewModel.email.onNext("test@example.com")
        viewModel.password.onNext("password123")
        
        viewModel.loginModelObservable
            .subscribe(onNext: { loginModel in
                XCTAssertEqual(loginModel.email, "test@example.com")
                XCTAssertEqual(loginModel.password, "password123")
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}

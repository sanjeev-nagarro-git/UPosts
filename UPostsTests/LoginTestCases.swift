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

//final class LoginTestCases: XCTestCase {
//    
//    private var viewModel: LoginViewModel!
//    private var disposeBag: DisposeBag!
//    
//    
//    func testLoginModelInitialization() {
//        // Arrange
//        let email = "test@example.com"
//        let password = "password123"
//        
//        // Act
//        let loginModel = LoginModel(email: email, password: password)
//        
//        // Assert
//        XCTAssertEqual(loginModel.email, email, "Email should be correctly initialized")
//        XCTAssertEqual(loginModel.password, password, "Password should be correctly initialized")
//    }
//    
//    override func setUp() {
//        super.setUp()
//        viewModel = LoginViewModel()
//        disposeBag = DisposeBag()
//    }
//    
//    override func tearDown() {
//        viewModel = nil
//        disposeBag = nil
//        super.tearDown()
//    }
//    
//    func testInitialEmailValue() {
//        // Arrange
//        let expectedInitialEmail = ""
//        
//        // Act & Assert
//        viewModel.email
//            .subscribe(onNext: { email in
//                XCTAssertEqual(email, expectedInitialEmail, "Initial email value should be empty")
//            })
//            .disposed(by: disposeBag)
//    }
//    
//    func testInitialPasswordValue() {
//        // Arrange
//        let expectedInitialPassword = ""
//        
//        // Act & Assert
//        viewModel.password
//            .subscribe(onNext: { password in
//                XCTAssertEqual(password, expectedInitialPassword, "Initial password value should be empty")
//            })
//            .disposed(by: disposeBag)
//    }
//    
//    func testEmailValueChange() {
//        // Arrange
//        let newEmail = "test@example.com"
//        
//        // Act
//        viewModel.email.onNext(newEmail)
//        
//        // Assert
//        viewModel.email
//            .subscribe(onNext: { email in
//                XCTAssertEqual(email, newEmail, "Email value should be updated correctly")
//            })
//            .disposed(by: disposeBag)
//    }
//    
//    func testPasswordValueChange() {
//        // Arrange
//        let newPassword = "newPassword123"
//        
//        // Act
//        viewModel.password.onNext(newPassword)
//        
//        // Assert
//        viewModel.password
//            .subscribe(onNext: { password in
//                XCTAssertEqual(password, newPassword, "Password value should be updated correctly")
//            })
//            .disposed(by: disposeBag)
//    }
//    
//    func testButtonEnabled() {
//        let expectedIsEnabled = true
//        let newEmail = "test@example.com"
//        let newPassword = "newPassword123"
//        viewModel.email.onNext(newEmail)
//        viewModel.password.onNext(newPassword)
//        
//        // Assert
//        viewModel.isSubmitButtonEnabled
//            .subscribe(onNext: { isEnabled in
//                XCTAssertEqual(isEnabled, expectedIsEnabled, "Submit button should be enabled when both email and password are non-empty")
//            })
//            .disposed(by: disposeBag)
//    }
//    
//}

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

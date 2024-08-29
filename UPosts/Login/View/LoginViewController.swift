//
//  LoginViewController.swift
//  UPosts
//
//  Created by Sanjeev Mishra on 28/08/24.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    let viewModel = LoginViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bindViewModel()
    }

    // Binding view with models
    private func bindViewModel() {
        emailTextField.rx.text
            .orEmpty
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text
            .orEmpty
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        
        viewModel.isSubmitButtonEnabled
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.moveToDashboard()
            })
            .disposed(by: disposeBag)
    }
    
    // Moving to tab bar controller containing Post and Favorite screens
    private func moveToDashboard() {
        let dashboardTabBar = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DashboardTabBarController")
        self.navigationController?.pushViewController(dashboardTabBar, animated: true)
    }
}

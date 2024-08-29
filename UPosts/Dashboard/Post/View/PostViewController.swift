//
//  PostViewController.swift
//  UPosts
//
//  Created by Sanjeev Mishra on 28/08/24.
//

import UIKit
import RxSwift
import RxCocoa

class PostViewController: UIViewController {
    @IBOutlet weak var postTableView: UITableView!
    let viewModel = PostViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = Constants.Post.screenTitle
    }
    
    // Setting up TableView
    private func setupUI() {
        postTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        postTableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // Binding tableview with datasource
    private func bindTableView() {
        viewModel.postsSubject
            .bind(to: postTableView.rx.items(cellIdentifier: "cell")) { index, post, cell in
                cell.textLabel?.text = post.title
                cell.accessoryType = post.isFavorite ? .checkmark : .none
            }
            .disposed(by: disposeBag)
        
        postTableView.rx.modelSelected(Post.self)
            .subscribe(onNext: { [weak self] item in
                self?.viewModel.handleCellClick(item)
            })
            .disposed(by: disposeBag)
        viewModel.fetchPosts()
    }
}

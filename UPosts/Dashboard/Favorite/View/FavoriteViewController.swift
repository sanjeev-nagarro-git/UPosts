//
//  FavoriteViewController.swift
//  UPosts
//
//  Created by Sanjeev Mishra on 28/08/24.
//

import UIKit
import RxSwift
import RxCocoa

class FavoriteViewController: UIViewController {
    private let viewModel = FavoriteViewModel()
    private let disposeBag = DisposeBag()
    private lazy var tableView: UITableView = {
        let tb = UITableView(frame: self.view.frame)
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.addSubview(tableView)
        bindTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = Constants.Favorite.screenTitle
        viewModel.getFavoritePosts()
    }
    
    // Bind Tablview with data
    private func bindTableView() {
        viewModel.favorites
            .bind(to: tableView.rx.items(cellIdentifier: "cell")) { index, post, cell in
                cell.textLabel?.text = post.title
            }
            .disposed(by: disposeBag)
    }
}

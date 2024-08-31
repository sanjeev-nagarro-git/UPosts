//
//  FavoriteViewController.swift
//  UPosts
//
//  Created by Sanjeev Mishra on 28/08/24.
//

import UIKit
import RxSwift
import RxCocoa
import CoreData

class FavoriteViewController: UIViewController {
    private var viewModel: FavoriteViewModel!
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
        let coreDataManager = CoreDataManager.shared
        // Initialize FavoriteViewModel with dependencies
        viewModel = FavoriteViewModel(coreDataManager: coreDataManager, fetchedResultsController: coreDataManager.favSearchResultController)
        addTableView()
        bindTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.title = Constants.Favorite.screenTitle
    }
    
    private func addTableView() {
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
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

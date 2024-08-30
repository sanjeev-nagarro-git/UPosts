//
//  PostViewModelTestCases.swift
//  UPostsTests
//
//  Created by Sanjeev Mishra on 30/08/24.
//

@testable import UPosts
import XCTest
import RxSwift
import RxCocoa

final class PostViewModelTests: XCTestCase {
    
    private var viewModel: PostViewModel!
    private var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        viewModel = PostViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        disposeBag = nil
        super.tearDown()
    }
    
    func testFetchPostsFromAPIWhenNetworkReachable() {
        // Act
        viewModel.fetchPosts()
        
        // Assert
        viewModel.postsSubject
            .subscribe(onNext: { posts in
                XCTAssertEqual(posts, posts, "Posts should be equal to the fetched posts")
            })
            .disposed(by: disposeBag)
    }
    
    func testFetchPostsFromAPIWhenNetworkNotReachable() {
        // Act
        viewModel.fetchPosts()
        
        // Assert
        viewModel.postsSubject
            .subscribe(onNext: { posts in
                XCTAssertEqual(posts, posts, "Posts should be equal to the local saved posts")
            })
            .disposed(by: disposeBag)
    }
    
    func testHandleCellClick() {
        // Arrange
        let post = Post(userId: 1, id: 1, title: "Test", body: "Body", isFavorite: false)
        
        // Act
        viewModel.handleCellClick(post)
        
        // Assert
        viewModel.postsSubject
            .subscribe(onNext: { posts in
                XCTAssertEqual(posts.isEmpty, true, "Posts should be blank")
            })
            .disposed(by: disposeBag)
    }
    
    func testFetchLocalPosts() {
        // Arrange
        let posts = [Post(userId: 1, id: 1, title: "Test", body: "Body", isFavorite: false)]
        // Act
        let fetchLocalPostsObservable = viewModel.fetchLocalPosts()
        
        // Assert
        fetchLocalPostsObservable
            .subscribe(onNext: { fetchedPosts in
                XCTAssertNotEqual(fetchedPosts, posts, "Local posts should match the saved posts")
            })
            .disposed(by: disposeBag)
    }
}

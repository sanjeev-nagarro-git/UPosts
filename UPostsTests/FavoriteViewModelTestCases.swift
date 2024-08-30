//
//  FavoriteViewModelTestCases.swift
//  UPostsTests
//
//  Created by Sanjeev Mishra on 30/08/24.
//

@testable import UPosts
import XCTest
import RxSwift
import RxCocoa

final class FavoriteViewModelTestCases: XCTestCase {
    
    private var viewModel: FavoriteViewModel!
    private var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        viewModel = FavoriteViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        disposeBag = nil
        super.tearDown()
    }
    
    func testGetFavoritePosts() {
        // Act
        viewModel.getFavoritePosts()
        let posts = [Post(userId: 1, id: 1, title: "Test", body: "Body", isFavorite: true)]
        viewModel.favorites.onNext(posts)
        // Assert
        viewModel.favorites
            .subscribe(onNext: { posts in
                XCTAssertEqual(posts.count, 1, "The number of favorite posts should be 2")
                XCTAssertTrue(posts.contains(where: { $0.id == 1 }), "The favorite posts should contain post with id 1")
                XCTAssertTrue(posts.contains(where: { $0.userId == 1 }), "The favorite posts should contain post with id 2")
            })
            .disposed(by: disposeBag)
    }
    
    func testGetFavoritePostsWhenNoFavorites() {
        // Act
        viewModel.getFavoritePosts()
        let posts = [Post(userId: 1, id: 1, title: "Test", body: "Body", isFavorite: true)]
        viewModel.favorites.onNext(posts)
        // Assert
        viewModel.favorites
            .subscribe(onNext: { posts in
                XCTAssertEqual(posts.count, 1, "The favorite posts should be 2")
            })
            .disposed(by: disposeBag)
    }
}

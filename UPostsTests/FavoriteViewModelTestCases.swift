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
import RealmSwift

final class FavoriteViewModelTests: XCTestCase {
    var viewModel: FavoriteViewModel!
        var mockRealmService: MockRealmFavoriteService!
        var disposeBag: DisposeBag!

        override func setUp() {
            super.setUp()
            mockRealmService = MockRealmFavoriteService()
            viewModel = FavoriteViewModel(realmService: mockRealmService)
            disposeBag = DisposeBag()
        }

        override func tearDown() {
            viewModel = nil
            mockRealmService = nil
            disposeBag = nil
            super.tearDown()
        }

        func testObserveFavoritesSuccess() {
            // Given
            let posts = [PostDTO(userId: 1, id: 1, title: "Title 1", body: "Body 1", isFavorite: true)]
            mockRealmService.observeFavoritePostsResult = .success(posts)

            // When
            viewModel.observeFavorites()

            // Then
            viewModel.favorites
                .subscribe(onNext: { fetchedPosts in
                    XCTAssertEqual(fetchedPosts.count, posts.count)
                    XCTAssertEqual(fetchedPosts.first?.title, posts.first?.title)
                })
                .disposed(by: disposeBag)
        }

        func testObserveFavoritesFailure() {
            // Given
            let error = NSError(domain: "TestError", code: 1, userInfo: nil)
            mockRealmService.observeFavoritePostsResult = .failure(error)

            // When
            viewModel.observeFavorites()

            // Then
            viewModel.favorites
                .subscribe(onNext: { fetchedPosts in
                    XCTAssertEqual(fetchedPosts.count, 0)
                })
                .disposed(by: disposeBag)
        }
}
class MockRealmFavoriteService: RealmFavoriteServiceProtocol {
    var observeFavoritePostsResult: Result<[PostDTO], Error>?
    var notificationToken: NotificationToken?

    func observeFavoritePosts(completion: @escaping (Result<[PostDTO], Error>) -> Void) -> NotificationToken? {
        if let result = observeFavoritePostsResult {
            completion(result)
        }
        return notificationToken
    }
}

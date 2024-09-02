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
    var viewModel: PostViewModel!
    var mockNetworkService: MockNetworkService!
    var mockRealmService: MockRealmService!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        mockRealmService = MockRealmService()
        viewModel = PostViewModel(networkService: mockNetworkService, realmService: mockRealmService)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        viewModel = nil
        mockNetworkService = nil
        mockRealmService = nil
        disposeBag = nil
        super.tearDown()
    }

    func testFetchPostsFromAPI() {
        // Given
        let posts = [PostDTO(userId: 1, id: 1, title: "Title 1", body: "Body 1", isFavorite: false)]
        mockNetworkService.fetchPostsResult = .success(posts)
        mockRealmService.fetchPostsResult = []

        // When
        viewModel.fetchPosts()

        // Then
        viewModel.postsSubject
            .subscribe(onNext: { fetchedPosts in
                XCTAssertEqual(fetchedPosts.count, posts.count)
                XCTAssertEqual(fetchedPosts.first?.title, posts.first?.title)
            })
            .disposed(by: disposeBag)
    }

    func testFetchPostsFromLocal() {
        // Given
        let posts = [PostDTO(userId: 1, id: 1, title: "Title 1", body: "Body 1", isFavorite: false)]
        mockRealmService.fetchPostsResult = posts

        // When
        viewModel.fetchPosts()

        // Then
        viewModel.postsSubject
            .subscribe(onNext: { fetchedPosts in
                XCTAssertNotEqual(fetchedPosts.count, posts.count)
                XCTAssertNotEqual(fetchedPosts.first?.title, posts.first?.title)
            })
            .disposed(by: disposeBag)
    }

    func testHandleCellClick() {
        // Given
        let post = PostDTO(userId: 1, id: 1, title: "Title 1", body: "Body 1", isFavorite: false)
        mockRealmService.fetchPostsResult = [post]

        // When
        viewModel.handleCellClick(post)

        // Then
        XCTAssertFalse(mockRealmService.updatePostFavoriteStatusCalled)
    }
}

class MockNetworkService: NetworkServiceProtocol {
    var fetchPostsResult: Result<[PostDTO], Error>?
    
    func fetchPostsFromAPI() -> Single<[PostDTO]> {
        return Single.create { single in
            if let result = self.fetchPostsResult {
                switch result {
                case .success(let posts):
                    single(.success(posts))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
}

class MockRealmService: RealmPostServiceProtocol {
    var fetchPostsResult: [PostDTO] = []
    var savePostsCalled = false
    var updatePostFavoriteStatusCalled = false
    
    func fetchPosts() -> [PostDTO] {
        return fetchPostsResult
    }
    
    func savePosts(_ posts: [PostDTO], completion: @escaping (Bool) -> Void) {
        savePostsCalled = true
        completion(true)
    }
    
    func updatePostFavoriteStatus(postId: Int, isFavorite: Bool) {
        updatePostFavoriteStatusCalled = true
    }
}

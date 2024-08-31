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
    var mockCoreDataManager: MockCoreDataManager!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        mockCoreDataManager = MockCoreDataManager()
        viewModel = PostViewModel(networkService: mockNetworkService, coreDataManager: mockCoreDataManager)
        disposeBag = DisposeBag()
        let post = PostDTO(userId: 1, id: 1, title: "Post 1", body: "Body - 1", isFavorite: false)
        mockCoreDataManager.posts = [post]
    }
    
    override func tearDown() {
        viewModel = nil
        mockNetworkService = nil
        mockCoreDataManager = nil
        disposeBag = nil
        super.tearDown()
    }
    
    func testFetchPostsFromAPI() {
        let posts = [PostDTO(userId: 1, id: 1, title: "Post 1", body: "Body - 1", isFavorite: false)]
        mockNetworkService.fetchPostsResult = .success(posts)
        
        let expectation = self.expectation(description: "Posts fetched from API")
        
        viewModel.postsSubject
            .skip(1) // Skip the initial value
            .subscribe(onNext: { fetchedPosts in
                XCTAssertEqual(fetchedPosts.count, posts.count)
                XCTAssertEqual(fetchedPosts.first?.title, posts.first?.title)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        viewModel.fetchPosts()
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testFetchPostsFromLocalDatabase() {
        let posts = [PostDTO(userId: 1, id: 1, title: "Post 1", body: "Body - 1", isFavorite: false)]
        mockCoreDataManager.posts = posts
        
        let expectation = self.expectation(description: "Posts fetched from local database")
        
        viewModel.postsSubject
            .skip(1) // Skip the initial value
            .subscribe(onNext: { fetchedPosts in
                XCTAssertEqual(fetchedPosts.count, posts.count)
                XCTAssertEqual(fetchedPosts.first?.title, posts.first?.title)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        viewModel.fetchPosts()
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testHandleCellClick() {
        let post = PostDTO(userId: 1, id: 1, title: "Post 1", body: "Body - 1", isFavorite: false)
        mockCoreDataManager.posts = [post]
        // Initialize the view model with the mock core data manager
        viewModel = PostViewModel(networkService: mockNetworkService, coreDataManager: mockCoreDataManager)
        let expectation = self.expectation(description: "Post favorite status toggled")
        
        viewModel.postsSubject
            .skip(1) // Skip the initial value
            .subscribe(onNext: { updatedPosts in
                print("Received updated posts: \(updatedPosts)")
                XCTAssertEqual(updatedPosts.first?.isFavorite, true)
                expectation.fulfill()
            }, onError: { error in
                XCTFail("Error occurred: \(error)")
            })
            .disposed(by: disposeBag)
        
        viewModel.handleCellClick(post)
        
        waitForExpectations(timeout: 5.0, handler: { error in
               if let error = error {
                   print("Test timed out with error: \(error)")
               }
           })
    }
}

class MockNetworkService: NetworkServiceProtocol {
    var fetchPostsResult: Result<[PostDTO], Error> = .success([])
    
    func fetchPostsFromAPI() -> Single<[PostDTO]> {
        return Single.create { single in
            switch self.fetchPostsResult {
            case .success(let posts):
                single(.success(posts))
            case .failure(let error):
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
}

class MockCoreDataManager: CoreDataManagerProtocol {
    var posts: [PostDTO] = []
    
    func fetchAllPosts() -> [PostDTO] {
        return posts
    }
    
    func savePosts(posts: [PostDTO], completion: @escaping (Bool) -> Void) {
        self.posts = posts
        completion(true)
    }
    
    func updatePostToFavorite(isFavorite: Bool, post: PostDTO) {
        if let index = posts.firstIndex(where: { $0.id == post.id }) {
            posts[index].isFavorite = isFavorite
        }
    }
}

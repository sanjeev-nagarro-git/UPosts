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
import CoreData

final class FavoriteViewModelTests: XCTestCase {
    
    var viewModel: FavoriteViewModel!
    var mockCoreDataManager: MockFavoriteCDataManager!
    var mockFetchedResultsController: MockFetchedResultsController!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        mockCoreDataManager = MockFavoriteCDataManager()
        mockFetchedResultsController = MockFetchedResultsController()
        viewModel = FavoriteViewModel(coreDataManager: mockCoreDataManager, fetchedResultsController: mockFetchedResultsController)
        disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        viewModel = nil
        mockCoreDataManager = nil
        mockFetchedResultsController = nil
        disposeBag = nil
        super.tearDown()
    }
    
    func testInitialFetch() {
        let post = Post(context: mockCoreDataManager.persistentContainer.viewContext)
        post.userId = 1
        post.id = 1
        post.title = "Post 1"
        post.body = "Body 1"
        post.isFavorite = true
        
        mockFetchedResultsController.fetchedObjects = [post]
        
        // Reinitialize the view model to ensure it fetches the initial data
        viewModel = FavoriteViewModel(coreDataManager: mockCoreDataManager, fetchedResultsController: mockFetchedResultsController)
        
        let expectation = self.expectation(description: "Initial fetch of favorite posts")
        
        viewModel.favorites
            .subscribe(onNext: { posts in
                XCTAssertEqual(posts.count, 1)
                XCTAssertEqual(posts.first?.title, "Post 1")
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}

class MockFavoriteCDataManager: FavoriteCDManagerProtocol {
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "UPosts")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load store: \(error)")
            }
        }
        return container
    }()
    
    var favoritePosts: [PostDTO] = []
    
    func fetchAllFavoritePosts() -> [PostDTO] {
        return favoritePosts
    }
}

class MockFetchedResultsController: NSObject, FetchedResultsControllerProtocol {
    weak var delegate: NSFetchedResultsControllerDelegate?
    
    var fetchedObjects: [Post]?
    
    func performFetch() throws {
        // Simulate fetching data
        delegate?.controllerDidChangeContent?(NSFetchedResultsController<NSFetchRequestResult>())
    }
}

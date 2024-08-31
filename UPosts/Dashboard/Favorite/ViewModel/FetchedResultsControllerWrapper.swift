//
//  FetchedResultsControllerWrapper.swift
//  UPosts
//
//  Created by Sanjeev Mishra on 30/08/24.
//

import Foundation
import CoreData

class FetchedResultsControllerWrapper: NSObject, FetchedResultsControllerProtocol {
    private let fetchedResultsController: NSFetchedResultsController<Post>
    
    weak var delegate: NSFetchedResultsControllerDelegate? {
        get { return fetchedResultsController.delegate }
        set { fetchedResultsController.delegate = newValue }
    }
    
    var fetchedObjects: [Post]? {
        return fetchedResultsController.fetchedObjects
    }
    
    init(fetchRequest: NSFetchRequest<Post>, managedObjectContext: NSManagedObjectContext) {
        self.fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        super.init()
        self.fetchedResultsController.delegate = self
    }
    
    func performFetch() throws {
        try fetchedResultsController.performFetch()
    }
}

extension FetchedResultsControllerWrapper: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.controllerDidChangeContent?(controller)
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        delegate?.controller?(controller, didChange: anObject, at: indexPath, for: type, newIndexPath: newIndexPath)
    }
}

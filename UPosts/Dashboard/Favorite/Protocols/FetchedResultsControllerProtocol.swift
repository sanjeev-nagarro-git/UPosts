//
//  FetchedResultsControllerProtocol.swift
//  UPosts
//
//  Created by Sanjeev Mishra on 30/08/24.
//

import CoreData

protocol FetchedResultsControllerProtocol: AnyObject {
    var delegate: NSFetchedResultsControllerDelegate? { get set }
    func performFetch() throws
    var fetchedObjects: [Post]? { get }
}

//
//  CoreDataManager.swift
//  UPosts
//
//  Created by Sanjeev Mishra on 29/08/24.
//

import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init(inMemory: Bool = false) {
        if inMemory {
            persistentContainer.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            } else {
                self.printPersistentStorePath()
            }
        })
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "UserPosts")
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Private Queue Context
    
    lazy var backgroundContext: NSManagedObjectContext = {
        let bgContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        bgContext.parent = context
        bgContext.automaticallyMergesChangesFromParent = true
        return bgContext
    }()
    
    // print path store directory
    private func printPersistentStorePath() {
           guard let storeURL = persistentContainer.persistentStoreDescriptions.first?.url else {
               print("Persistent store URL not found.")
               return
           }
           print("Persistent store URL: \(storeURL.path)")
       }
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // Background context
    private func saveBackgroundContext() {
        let bgContext = backgroundContext
        if context.hasChanges {
            do {
                try bgContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // Saving post from API in core data
    func savePosts(posts: [Post], completion: @escaping (Error?) -> Void) {
        let bgContext = backgroundContext
        bgContext.perform { [weak self] in
            do {
                // Create Post entities for each Post object
                for post in posts {
                    let postEntity = Posts(context: bgContext)
                    postEntity.userId = Int32(post.userId)
                    postEntity.id = Int32(post.id)
                    postEntity.title = post.title
                    postEntity.body = post.body
                    postEntity.isFavorite = false
                }
                try bgContext.save()
                self?.saveContext()
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    // Update Post about is Favorite or not
    func updatePostToFavorite(isFavorite: Bool, post: Post) {
        let fetchRequest: NSFetchRequest<Posts> = Posts.fetchRequest() // Replace PostEntity with your Core Data entity name
        
        // Create a predicate to fetch the specific post by its ID
        let predicate = NSPredicate(format: "id == %d", post.id)
        fetchRequest.predicate = predicate
        do {
            // Fetch the post entity
            let postEntities = try context.fetch(fetchRequest)
            
            // Ensure we have exactly one result
            guard let postEntity = postEntities.first else {
                print("Post with ID \(post.id) not found.")
                return
            }
            
            // Update the isFavorite attribute
            postEntity.isFavorite = isFavorite
            
            // Save the context to persist changes
            try context.save()
        } catch {
            print("Failed to update post: \(error)")
        }
    }
    
    // fetching all posts from core data
    func fetchAllPosts() -> [Post] {
        let fetchRequest: NSFetchRequest<Posts> = Posts.fetchRequest()
        do {
            let postEntities = try context.fetch(fetchRequest)
            return postEntities.map { postEntity in
                return Post(
                    userId: Int(postEntity.userId),
                    id: Int(postEntity.id),
                    title: postEntity.title ?? "",
                    body: postEntity.body ?? "",
                    isFavorite: postEntity.isFavorite
                )
            }
        } catch {
            print("Failed to fetch posts: \(error)")
            return []
        }
    }
    
    // Fetching all favorite posts from core data
    func fetchAllFavoritePosts() -> [Post] {
        let fetchRequest: NSFetchRequest<Posts> = Posts.fetchRequest()
        let predicate = NSPredicate(format: "isFavorite == %@", NSNumber(value: true))
        fetchRequest.predicate = predicate
        do {
            let postEntities = try context.fetch(fetchRequest)
            return postEntities.map { postEntity in
                return Post(
                    userId: Int(postEntity.userId),
                    id: Int(postEntity.id),
                    title: postEntity.title ?? "",
                    body: postEntity.body ?? "",
                    isFavorite: postEntity.isFavorite
                )
            }
        } catch {
            print("Failed to fetch posts: \(error)")
            return []
        }
    }
}


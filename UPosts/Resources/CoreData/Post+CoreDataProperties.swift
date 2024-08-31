//
//  Post+CoreDataProperties.swift
//  UPosts
//
//  Created by Sanjeev Mishra on 30/08/24.
//
//

import Foundation
import CoreData


extension Post {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post")
    }

    @NSManaged public var id: Int32
    @NSManaged public var userId: Int32
    @NSManaged public var title: String?
    @NSManaged public var body: String?
    @NSManaged public var isFavorite: Bool

}

extension Post : Identifiable {

}

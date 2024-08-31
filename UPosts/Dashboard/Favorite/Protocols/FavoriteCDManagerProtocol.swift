//
//  FavoriteCDManagerProtocol.swift
//  UPosts
//
//  Created by Sanjeev Mishra on 30/08/24.
//

import Foundation
import CoreData

protocol FavoriteCDManagerProtocol {
    var persistentContainer: NSPersistentContainer { get }
    func fetchAllFavoritePosts() -> [PostDTO]
}

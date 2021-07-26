//
//  CoreDataStack.swift
//  TravelMap
//
//  Created by Даниил Петров on 16.07.2021.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TravelMap")
        container.loadPersistentStores { desc, error in
            if let error = error {
                fatalError("CoreData fatal error: \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    var viewContext: NSManagedObjectContext { container.viewContext }
    lazy var backgroundContext: NSManagedObjectContext = container.newBackgroundContext()
    
    private init() { }
}

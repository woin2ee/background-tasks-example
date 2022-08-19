//
//  CoreDataStorage.swift
//  BackgroundTasks
//
//  Created by Jaewon on 2022/08/18.
//

import CoreData
import OSLog

enum CoreDataError: Error {
    case readError
}

final class CoreDataStorage {
    
    static let shared = CoreDataStorage.init()
    
    private init() {}
    
    // MARK: - Core Data stack
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataStorage")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                Logger.coreData.error("CoreDataStorage Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        self.persistentContainer.viewContext
    }
    
    // MARK: - Core Data Saving support
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                Logger.coreData.error("CoreDataStorage Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

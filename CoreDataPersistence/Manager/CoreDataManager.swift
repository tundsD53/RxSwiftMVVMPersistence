//
//  CoreDataManager.swift
//  CoreDataPersistence
//
//  Created by Tunde on 04/06/2019.
//  Copyright © 2019 Degree 53 Limited. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    // MARK: - Contexts
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "CoreDataPersistence")
        return persistentContainer
    }()
    
    lazy var backgroundContext: NSManagedObjectContext = {
        let context = self.persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }()
    
    lazy var mainContext: NSManagedObjectContext = {
        let context = self.persistentContainer.viewContext
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }()
    
    // MARK: - Singleton
    
    static let shared = CoreDataManager()
    
    // MARK: - Init
    
    private init () {}
    
    // MARK: - Save
    
    func saveContext () {
        
        if self.mainContext.hasChanges {
            do {
                try self.mainContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Setup
    
    func setup(_ completion: (()->())? = nil) {
        loadPersistentStore {
            completion?()
        }
    }
    
    
    // MARK: - Loading
    
    private func loadPersistentStore(completion: @escaping () -> Void) {
        self.persistentContainer.loadPersistentStores { description, error in
            guard error == nil else {
                fatalError("was unable to load store \(error!)")
            }
            completion()
        }
    }
}

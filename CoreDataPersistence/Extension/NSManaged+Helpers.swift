//
//  Codeable+Helpers.swift
//  CoreDataPersistence
//
//  Created by Tunde on 05/06/2019.
//  Copyright © 2019 Degree 53 Limited. All rights reserved.
//

import Foundation
import CoreData

extension PersistedObject where Self: NSManagedObject  {
    static func storedObjects() -> Array<Self> {
        if let entity = entity().name {
            let fetchRequest = NSFetchRequest<Self>(entityName: entity)
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
            let results = try? CoreDataManager.shared.mainContext.fetch(fetchRequest)
            return results ?? []
        }
        return []
    }
}

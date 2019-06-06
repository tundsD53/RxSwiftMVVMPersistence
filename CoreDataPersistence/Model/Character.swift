//
//  Character.swift
//  CoreDataPersistence
//
//  Created by Tunde on 04/06/2019.
//  Copyright © 2019 Degree 53 Limited. All rights reserved.
//

import Foundation
import CoreData

@objc(Character)
class Character: NSManagedObject, PersistedObject {
    
    @NSManaged var id: Int16
    @NSManaged var name: String?
    @NSManaged var status: String?
    @NSManaged var species: String?
    @NSManaged var type: String?
    @NSManaged var gender: String?
    @NSManaged var origin: Additional?
    @NSManaged var location: Additional?
    @NSManaged var image: String?
    @NSManaged var episode: Array<String>?
    @NSManaged var url: String?
    @NSManaged var created: Date?
    
    enum CodingKeys: String, CodingKey {
        case id, name, status, species, type, gender, origin, location, image, episode, url, created
    }
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        super.init(entity: Character.entity(), insertInto: CoreDataManager.shared.mainContext)
        self.id = try container.decode(Int16.self, forKey: .id)
        self.name = try container.decode(String?.self, forKey: .name)
        self.status = try container.decode(String?.self, forKey: .status)
        self.species = try container.decode(String?.self, forKey: .species)
        self.type = try container.decode(String?.self, forKey: .type)
        self.gender = try container.decode(String?.self, forKey: .gender)
        self.origin = try container.decode(Additional?.self, forKey: .origin)
        self.location = try container.decode(Additional?.self, forKey: .location)
        self.image = try container.decode(String?.self, forKey: .image)
        self.episode = try container.decode(Array<String>?.self, forKey: .episode)
        self.url = try container.decode(String?.self, forKey: .url)
        self.created = try container.decode(Date?.self, forKey: .created)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(status, forKey: .status)
        try container.encode(species, forKey: .species)
        try container.encode(type, forKey: .type)
        try container.encode(gender, forKey: .gender)
        try container.encode(origin, forKey: .origin)
        try container.encode(image, forKey: .image)
        try container.encode(episode, forKey: .episode)
        try container.encode(url, forKey: .url)
        try container.encode(created, forKey: .created)
    }
}


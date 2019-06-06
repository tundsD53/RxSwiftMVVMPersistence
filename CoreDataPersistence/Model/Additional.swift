//
//  Additional.swift
//  CoreDataPersistence
//
//  Created by Tunde on 04/06/2019.
//  Copyright © 2019 Degree 53 Limited. All rights reserved.
//

import Foundation

class Additional: NSObject, NSCoding, Codable {
    
    var name: String?
    var url: String?
    
    enum CodingKeys: String, CodingKey {
        case name, url
    }
    
    func encode(with aCoder: NSCoder) {
    
        aCoder.encode(name, forKey: CodingKeys.name.rawValue)
        aCoder.encode(url, forKey: CodingKeys.url.rawValue)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.name = aDecoder.decodeObject(forKey: CodingKeys.name.rawValue) as? String
        self.url = aDecoder.decodeObject(forKey: CodingKeys.url.rawValue) as? String
    }
}

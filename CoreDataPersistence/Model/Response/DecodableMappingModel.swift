//
//  DecodableMappingModel.swift
//  CoreDataPersistence
//
//  Created by Tunde on 05/06/2019.
//  Copyright © 2019 Degree 53 Limited. All rights reserved.
//

import Foundation

struct DecodableMappingModel {
    var jsonDecoder: JSONDecoder
    var keyPath: String?
    var failsOnEmpty: Bool
}

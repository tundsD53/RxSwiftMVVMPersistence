//
//  GenderTransformer.swift
//  CoreDataPersistence
//
//  Created by Tunde on 04/06/2019.
//  Copyright © 2019 Degree 53 Limited. All rights reserved.
//

import Foundation
import UIKit

class GenderTransformer: ValueTransformer {
    
    override class func transformedValueClass() -> AnyClass {
        return NSString.self
    }
    
    override class func allowsReverseTransformation() -> Bool {
        return true
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let val = value as? NSString else { return nil }
        return Gender(rawValue: val.description)
    }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let status = value as? Gender else { return nil }
        return NSString(string: status.rawValue)
    }
}

//
//  ResponseObject.swift
//  CoreDataPersistence
//
//  Created by Tunde on 05/06/2019.
//  Copyright © 2019 Degree 53 Limited. All rights reserved.
//

import Moya

struct ResponseObject<T> {
    let response: Moya.Response?
    let data: T?
}

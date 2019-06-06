//
//  ResponseResultType.swift
//  CoreDataPersistence
//
//  Created by Tunde on 05/06/2019.
//  Copyright © 2019 Degree 53 Limited. All rights reserved.
//

enum ResponseResultType<T> {
    case success(response: ResponseObject<T>)
    case failure(error: Error)
}

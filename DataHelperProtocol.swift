//
//  DataHelperProtocol.swift
//
//  Created by Mario Kovacevic on 14/06/15.
//  Copyright (c) 2015 Mario Kovacevic. All rights reserved.
//

import Foundation
import SQLite

// this are default methods that needs to be created, you can modify this if you want
protocol DataHelperProtocol {
    typealias T
    static func createTable() -> Void
    static func insert(item: T) -> Bool
    static func update(item: T) -> Bool
    static func delete(item: T) -> Bool
    static func populateObject(item:Row) -> T?
}
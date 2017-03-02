//
//  DataHelperProtocol.swift
//  Country
//
//  Created by Mario Kovacevic on 09/05/16.
//

import Foundation
import SQLite

/**
 This are default methods that needs to be created, you can modify this if you want.
 */
protocol DataHelperProtocol {
    associatedtype T
    static func createTable() throws -> Void
    static func insert(_ item: T) -> Bool
    static func update(_ item: T) -> Bool
    static func delete(_ item: T) -> Bool
    static func populateObject(_ item:Row) -> T?
}

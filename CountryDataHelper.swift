//
//  CountryDataHelper.swift
//
//  Created by Mario Kovacevic on 18/06/15.
//  Copyright (c) 2015 Mario Kovacevic. All rights reserved.
//

import Foundation
import SQLite

class CountryDataHelper: DataHelperProtocol {
    static let TABLE_NAME = "country"
    
    static let id = Expression<Int>("id")
    static let name = Expression<String?>("name")
    static let capital = Expression<String?>("capital")
    static let region = Expression<String?>("region")
    
    static let table = Table(TABLE_NAME)
    static let db = SQLiteDataStore.sharedInstance.DB
    
    typealias T = CountryModel
    
    static func createTable() {
        do {
            try SQLiteDataStore.sharedInstance.DB.run(table.create { t in
                t.column(id, primaryKey: .Autoincrement)
                t.column(name)
                t.column(capital)
                t.column(region)
                })
        } catch {
            print("Error!")
        }
    }
    
    static func insert(item: T) -> Bool {
        do {
            let rowid = try db.run(table.insert(name <- item.name, capital <- item.capital, region <- item.region))
            if rowid > 0 {
                print("inserted id: \(rowid)")
                return true
            } else {
                return false
            }
        } catch {
            print("insertion failed: \(error)")
            return false
        }
    }
    
    static func update(item: T) -> Bool {
        do {
            if (item.id != nil) {
                let query = table.filter(id == item.id!)
                let rowid = try db.run(query.update(name <- item.name, capital <- item.capital, region <- item.region))
                if rowid > 0 {
                    print("updated id: \(rowid)")
                    return true
                } else {
                    return false
                }
            }
            print("inserted id: \(rowid)")
            return false
        } catch {
            print("insertion failed: \(error)")
            return false
        }
    }
    
    static func delete (item: T) -> Bool {
        do {
            if let countryId = item.id {
                let query = table.filter(id == countryId)
                let rowid = try db.run(query.delete())
                if rowid > 0 {
                    print("delete id: \(rowid)")
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
        } catch {
            print("delete failed: \(error)")
            return false
        }
    }
    
    static func find(countryId: Int) -> T? {
        let query = table.filter(id == countryId)
        var results: T?
        if let item = db.pluck(query) {
            results = self.populateObject(item)
        }
        return results
    }
    
    static func findAll() -> [T]? {
        var retArray = [T]()
        do {
            try db.transaction { txn in
                for item in try db.prepare(table) {
                    retArray.append(self.populateObject(item)!)
                }
            }
        } catch {
            print("Error!")
        }
        return retArray
    }
    
    
    // Using the transaction and savepoint functions, we can run a series of statements in a transaction. 
    // If a single statement fails or the block throws an error, the changes will be rolled back.
    static func importCountries(countries:[T]?, onCompletion: () -> Void){
        if countries != nil {
            do {
                try db.transaction { txn in
                    for country in countries! {
                        if self.update(country) != true {
                            self.insert(country)
                        }
                    }
                }
            } catch {
                print("Error!")
            }
        }
        onCompletion()
    }
    
    // If you change your model, this is the only place for populating it :-)
    static func populateObject(item:Row) -> T? {
        let country: CountryModel = CountryModel()
        country.id = item[id]
        if item[name] != nil {
            country.name = item[name]
        }
        if item[capital] != nil {
            country.capital = item[capital]
        }
        if item[region] != nil {
            country.region = item[region]
        }
        return country
    }
}
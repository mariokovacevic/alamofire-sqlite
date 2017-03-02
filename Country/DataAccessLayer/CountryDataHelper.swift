//
//  CountryDataHelper.swift
//  Country
//
//  Created by Mario Kovacevic on 09/05/16.
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
    
    typealias T = CountryModel
    
    /**
     Example of how you can create a table in database.
     */
    static func createTable() throws {
        do {
            _ = try SQLiteDataStore.sharedInstance.DB!.run(table.create { t in
                t.column(id, primaryKey: true)
                t.column(name)
                t.column(capital)
                t.column(region)
                })
        } catch {
            print("Error!")
        }
    }
    
    /**
     Example of how you can insert one country in database.
     */
    static func insert(_ item: T) -> Bool {
        do {
            let rowid = try SQLiteDataStore.sharedInstance.DB!.run(table.insert(name <- item.name, capital <- item.capital, region <- item.region))
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
    
    /**
     Example of how you can update one country in database using 'name' parameter to find which one to update.
     */
    static func update(_ item: T) -> Bool {
        do {
            if (item.name != nil) {
                let query = table.filter(name == item.name!)
                let rowid = try SQLiteDataStore.sharedInstance.DB!.run(query.update(capital <- item.capital, region <- item.region))
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
    
    /**
     Example of how you can delete one country from database.
     */
    static func delete (_ item: T) -> Bool {
        do {
            if let countryId = item.id {
                let query = table.filter(id == countryId)
                let rowid = try SQLiteDataStore.sharedInstance.DB!.run(query.delete())
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
    
    /**
     Example of how you can find just one country using countru id.
     */
    static func find(_ countryId: Int) -> T? {
        let query = table.filter(id == countryId)
        var results: T?
        do {
            if let item = try SQLiteDataStore.sharedInstance.DB!.pluck(query) {
                results = self.populateObject(item)
            }
        } catch {
            print("Error!")
        }

        return results
    }
    
    /**
     Example of how you can fatch all countries from database.
     */
    static func findAll() -> [T]? {
        var retArray = [T]()
        do {
            for item in try SQLiteDataStore.sharedInstance.DB!.prepare(table) {
                retArray.append(self.populateObject(item)!)
            }
        } catch {
            print("Error!")
        }
        return retArray
    }
    
    /**
     Example of how countries are find in database using region parameter.
     */
    static func findAllForRegion(_ reg:Navigation) -> [T]? {
        let query = table.filter(region == reg.rawValue)
        
        var retArray = [T]()
        do {
            for item in try SQLiteDataStore.sharedInstance.DB!.prepare(query) {
                retArray.append(self.populateObject(item)!)
            }
        } catch {
            print("Error!")
        }
        return retArray
    }
    
    /**
     Using the transaction and savepoint functions, we can run a series of statements in a transaction.
     If a single statement fails or the block throws an error, the changes will be rolled back.
     */
    static func importCountries(_ countries:[T]?, onCompletion: () -> Void){
        if countries != nil {
            do {
                try SQLiteDataStore.sharedInstance.DB!.transaction { txn in
                    for country in countries! {
                        if self.update(country) != true {
                            _ = self.insert(country)
                        }
                    }
                }
            } catch {
                print("Error!")
            }
        }
        onCompletion()
    }
    
    /**
     If you change your model, this is the only place for populating it.
     */
    static func populateObject(_ item:Row) -> T? {
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

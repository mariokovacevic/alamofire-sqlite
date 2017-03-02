//
//  SchemaVersioning.swift
//  Country
//
//  Created by Mario Kovacevic on 09/05/16.
//

import Foundation
import SQLite
import Async

class SchemaVersioning {
    
    static let versonsForUpgrade = 1;
    
    static func databaseMigration() {
        let version = SQLiteDataStore.sharedInstance.userVersion
        print("CURRENT PRAGMA VERSION:  \(version)", terminator: "")
        
        for i in 0 ... self.versonsForUpgrade {
            if (i > version){
                self.migrateVersion(i)
            }
        }
    }
    
    static func migrateVersion(_ upgradeToVersion:Int) {
        print("UPGRADE TO VERSION:  \(upgradeToVersion)", terminator: "")
        switch upgradeToVersion {
        case 1:
            do {
                try self.createTables()
            } catch let error as NSError {
                print("Failed to create table: \(error.localizedDescription)")
            }
            print("USER VERSION:  \(upgradeToVersion)", terminator: "")
        case 2:
            print("USER VERSION:  \(upgradeToVersion)", terminator: "")
        case 3:
            print("USER VERSION:  \(upgradeToVersion)", terminator: "")
        default:
            print("NO CASE IN SWITCH FOR USER VERSION:  \(upgradeToVersion)", terminator: "")
        }
        SQLiteDataStore.sharedInstance.userVersion = upgradeToVersion
    }
    
    static func createTables() throws {
        try CountryDataHelper.createTable()
    }
    
}

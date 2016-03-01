//
//  SchemaVersioning.swift
//
//  Created by Mario Kovacevic on 26/06/15.
//  Copyright (c) 2015 Mario Kovacevic. All rights reserved.
//

import Foundation
import SQLite
import Async

class SchemaVersioning {
    
    static let versonsForUpgrade = 1;
    static var db:Connection!
    
    static func databaseMigration() {
        db = SQLiteDataStore.sharedInstance.DB
        let version = SQLiteDataStore.sharedInstance.userVersion
        print("CURRENT PRAGMA VERSION:  \(version)", terminator: "")
        
        _ = Async.background {
            for var i = 0; i <= self.versonsForUpgrade; ++i {
                if (i > version){
                    self.migrateVersion(i)
                }
            }
        }
    }
    
    static func migrateVersion(upgradeToVersion:Int) {
        print("UPGRADE TO VERSION:  \(upgradeToVersion)", terminator: "")
        switch upgradeToVersion {
        case 1:
            self.createTables()
            print("USER VERSION:  \(upgradeToVersion)", terminator: "")
        default:
            print("NO CASE IN SWITCH FOR USER VERSION:  \(upgradeToVersion)", terminator: "")
        }
        SQLiteDataStore.sharedInstance.userVersion = upgradeToVersion
    }
    
    static func createTables() {
        CountryDataHelper.createTable()
    }
    
}

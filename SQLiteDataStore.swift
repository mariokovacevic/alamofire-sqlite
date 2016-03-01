//
//  DBHelper.swift
//
//  Created by Mario Kovacevic on 13/06/15.
//  Copyright (c) 2015 Mario Kovacevic. All rights reserved.
//

import Foundation
import SQLite

class SQLiteDataStore {
    static let sharedInstance = SQLiteDataStore()
    let DB: Connection!
    
    private init() {
        let name = NSBundle.mainBundle().infoDictionary!["CFBundleName"] as! String + ".sqlite"
        let dirs : [String] = (NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true))
        let dir = dirs[0]
        let path = dir + "/" + name
        
        print("DATABASE_PATH: \(path)")
        
        do {
            DB = try Connection(path)
        } catch {
            DB = nil
            print("Error!")
        }
        
        DB.trace { msg in
            print("message: \(msg)")
        }
    }
    
    internal var userVersion: Int {
        get {
            do {
                let count = DB.scalar("PRAGMA user_version") as! Int64
                return Int(count)
            }
        }
        set {
            do {
               try DB.run("PRAGMA user_version = \(newValue)")
            } catch {
                print("Error!")
            }
        }
    }

}

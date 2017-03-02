//
//  SQLiteDataStore.swift
//  Country
//
//  Created by Mario Kovacevic on 09/05/16.
//

import Foundation
import SQLite

class SQLiteDataStore {
    var DB: Connection?
    
    class var sharedInstance: SQLiteDataStore {
        struct Static {
            static var instance = SQLiteDataStore()
        }
        if Static.instance.DB == nil {
            Static.instance = SQLiteDataStore()
        }
        return Static.instance
    }
    
    fileprivate init() {
        
        print("DATABASE_PATH: \(SQLiteDataStore.getDatabasePath())")
        
        self.createConnection()
    }
    
    fileprivate func createConnection() {
        do {
            DB = try Connection(SQLiteDataStore.getDatabasePath())
            guard DB != nil else {
                fatalError("There is no connection for database")
            }
            
            DB!.trace { msg in
                print("message: \(msg)")
            }
        } catch {
            fatalError("Error catch: No connection for database")
        }
    }
    
    static func getDatabasePath() -> String {
        let documentDirectoryURL =  try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return documentDirectoryURL.appendingPathComponent(SQLiteDataStore.getAppName()).path
    }
    
    static func getAppName() -> String {
        // get app name from bundle
        let appName:String? = Bundle.main.infoDictionary!["CFBundleName"] as! String + ".sqlite"
        guard appName != nil else {
            fatalError("There is no App name")
        }
        return appName!
    }
    
    internal var userVersion: Int {
        get {
            var count:Int64? = 0
            do {
               count = try DB!.scalar("PRAGMA user_version") as? Int64
            } catch {
                print("Error!")
            }
            return Int(count!)
        }
        set {
            do {
                _ = try DB!.run("PRAGMA user_version = \(newValue)")
            } catch {
                print("Error!")
            }
        }
    }
    
    static func deleteDatabase(){
        SQLiteDataStore.sharedInstance.DB = nil
        
        let filemgr = FileManager.default
        var error: NSError?
        do {
            if filemgr.fileExists(atPath: SQLiteDataStore.getDatabasePath()) == true {
                try filemgr.removeItem(atPath: SQLiteDataStore.getDatabasePath())
            }
        } catch let error1 as NSError {
            error = error1
            print("Failed to delete database: \(error!.localizedDescription)")
        }
    }
    
}

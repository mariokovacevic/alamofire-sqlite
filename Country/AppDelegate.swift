//
//  AppDelegate.swift
//  Country
//
//  Created by Mario Kovacevic on 09/05/16.
//

import UIKit
import IQKeyboardManager
import SwiftyUserDefaults

enum KeychainKeys: String {
    case password           = "password"
}

// All segue identifiers used in app
enum SegueIdentifier: String {
    case Main               = "main_sw"
    case Login              = "loginAccountSegue"
    case CreateAccount      = "createAccountSegue"
    case Settings           = "settingsSeague"
    case Countries          = "contriesSeague"
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
    
        self.initDefaultKeys()
        
        UINavigationBar.appearance().barStyle = .blackTranslucent
        IQKeyboardManager.shared().isEnabled = true
        SchemaVersioning.databaseMigration()// create database and perform versioning if needed
        
        return true
    }
    
    func initDefaultKeys() {
        Defaults[.showNavigation] = true
        if !Defaults.hasKey(.autologin){
            Defaults[.autologin] = false
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        Defaults[.showInterstitial] = false
    }
    
    static func pushAndAdsPath() -> String {
        return Bundle.main.path(forResource: "PushAndAds", ofType: "plist")!
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        Defaults[.showInterstitial] = true
    }

}


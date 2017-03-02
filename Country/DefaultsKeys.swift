//
//  DefaultsKeys.swift
//  Country
//
//  Created by Mario Kovacevic on 13/05/16.
//

import Foundation
import SwiftyUserDefaults

/**
Keys for NSUserDefaults used in the app.
*/
extension DefaultsKeys {
    static let showNavigation = DefaultsKey<Bool>("showNavigation")
    static let showInterstitial = DefaultsKey<Bool>("showInterstitial")
    static let autologin = DefaultsKey<Bool>("autologin")
    static let email = DefaultsKey<String>("email")
}

//
//  APIHelper.swift
//  Country
//
//  Created by Mario Kovacevic on 09/05/16.
//

import Foundation
import Alamofire
import SwiftyJSON
import SwiftyUserDefaults
import SwiftKeychainWrapper
import AlamofireObjectMapper

class APIHelper {
    /**  
     Replace this url with your own. 
     https://restcountries.eu is used as an example of one.
     */
    static let BASE_URL = "https://restcountries.eu"
    
    /**
     Modify this enum to work with your own services.
     */
    enum API: String {
        case countries = "/rest/v1/all"
        case register = "/register"
        case login = "/login"
    }
    
    /**
     Isn't this awesome, countries json is converted to array of CountryModel. You can use this methot for all GET requests in your app. 
     Make sure you created a model for that request first.
     */
    static func countries(_ onCompletion: @escaping ([CountryModel]?) -> Void){
        let request = Alamofire.request(BASE_URL + API.countries.rawValue)
        request.responseArray { (response: DataResponse<[CountryModel]>) in
            let countries = response.result.value
            if countries != nil {
                onCompletion(countries!)
            } else {
                onCompletion(nil)
            }
        }
    }
    
    
    /**
     Modify this method to work with your own login service or just uncomment the below code if you use token auth.
     */
    static func login(_ email: String, password:String, onCompletion: (Bool) -> Void){
        if email == Defaults[.email] {
            let savedPassword: String? = KeychainWrapper.standard.string(forKey: KeychainKeys.password.rawValue)
            if password == savedPassword {
                onCompletion(true)
            } else {
                onCompletion(false)
            }
        } else {
            onCompletion(false)
        }
    }
    
    /**
     Modify this method to work with your own register service or just uncomment the below code.
     */
    static func register(_ email: String, password:String, onCompletion: (Bool) -> Void){
        Defaults[.email] = email
        if KeychainWrapper.standard.set(password, forKey: KeychainKeys.password.rawValue) {
            onCompletion(true)
        } else {
            onCompletion(false)
        }
    }
    
}

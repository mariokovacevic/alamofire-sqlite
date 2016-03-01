//
//  APIHelper.swift
//  AlamofireSQLiteExample
//
//  Created by Mario Kovacevic on 19/10/15.
//  Copyright © 2015 Mario Kovacevic. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum API {
    case countries
}

class APIHelper {
    
    static let BASE_URL = "https://restcountries.eu"
    
    static var token:String?
    
    static var alamofireManager : Alamofire.Manager?
    
    static func config() -> Alamofire.Manager{
        var addedHeaders = Manager.defaultHTTPHeaders
        if self.token != nil {
            addedHeaders["Authentication"] = self.token
        }
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.timeoutIntervalForResource = 2
        configuration.HTTPAdditionalHeaders = addedHeaders
        NSLog("Authorization-Header: \(configuration.HTTPAdditionalHeaders)")
        
        alamofireManager = Alamofire.Manager(configuration: configuration)
        return alamofireManager!
    }
    
    static func countries(onCompletion: ([CountryModel]?) -> Void){
        let request = self.config().request(.GET, service(API.countries))

        request.responseArray { (response: [CountryModel]?, error: ErrorType?) in
            if response != nil {
                onCompletion(response!)
            } else {
                onCompletion(nil)
            }
        }
    }
    
    static func service(api:API) -> String{
        switch api {
        case .countries:
            return BASE_URL + "/rest/v1/all"
        }
    }
    
}

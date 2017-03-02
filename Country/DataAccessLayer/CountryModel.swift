//
//  CountryModel.swift
//  Country
//
//  Created by Mario Kovacevic on 09/05/16.
//

import Foundation
import ObjectMapper

class CountryModel:Mappable {
    
    var id: Int?
    var name: String?
    var capital: String?
    var region: String?
    
    init() {
        
    }
    
    required init?(map: Map){
        
    }
    
    /**
     When save method is called. Update will be triggered, if update is not successful, there is no such country in database and insert will be made.
     */
    func save() -> Bool{
        var success:Bool = false
        
        success = CountryDataHelper.update(self)
        if success != true {
            success = CountryDataHelper.insert(self)
        }
        
        return success
    }
    
    /**
     Delete model
     */
    func delete() -> Bool{
        return CountryDataHelper.delete(self)
    }
    
    /**
     Map the model with JSON returned from server. More on https://github.com/Hearst-DD/ObjectMapper
     */
    func mapping(map: Map) {
        name <- map["name"]
        capital <- map["capital"]
        region <- map["region"]
    }
    
    /**
     Convert model to JSON String if you need to send it to server.
     */
    func toJSONString() -> String{
        return Mapper().toJSONString(self, prettyPrint: true)!
    }
}

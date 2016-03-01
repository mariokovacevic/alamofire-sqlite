//
//  CountryModel.swift
//
//  Created by Mario Kovacevic on 18/06/15.
//  Copyright (c) 2015 Mario Kovacevic. All rights reserved.
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
    
    required init?(_ map: Map){
        
    }
    
    func save() -> Bool{
        var success:Bool = false
        
        success = CountryDataHelper.update(self)
        if success != true {
            success = CountryDataHelper.insert(self)
        }
        
        return success
    }
    
    func delete() -> Bool{
        return CountryDataHelper.delete(self)
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        capital <- map["capital"]
        region <- map["region"]
    }
    
    func toJSONString() -> String{
        return Mapper().toJSONString(self, prettyPrint: true)!
    }
}

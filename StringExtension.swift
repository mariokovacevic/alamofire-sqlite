//
//  StringExtension.swift
//
//  Created by Mario Kovacevic on 19/10/15.
//  Copyright © 2015 Mario Kovacevic. All rights reserved.
//

import Foundation

extension String {
    static func className(aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).componentsSeparatedByString(".").last!
    }
    
    var isEmail: Bool {
        let regex = try? NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .CaseInsensitive)
        return regex?.firstMatchInString(self, options: [], range: NSMakeRange(0, self.characters.count)) != nil
    }
    
    var isFullName: Bool {
        let nameArray: [String] = self.characters.split { $0 == " " }.map { String($0) }
        return nameArray.count >= 2
    }
    
    var isPassword: Bool {
        if self.characters.count >= 8 {
            return true
        } else {
            return false
        }
    }

}
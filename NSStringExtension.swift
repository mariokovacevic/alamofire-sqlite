//
//  NSStringExtension.swift
//
//  Created by Mario Kovacevic on 16/10/15.
//  Copyright © 2015 Mario Kovacevic. All rights reserved.
//

import Foundation

extension NSString {
    
    func replaceCharactersInString(from:String, to:String) -> String {
        return self.stringByReplacingOccurrencesOfString(from, withString: to)
    }
    
}
//
//  CountriesTableViewCell.swift
//
//  Created by Mario Kovacevic on 16/10/15.
//  Copyright © 2015 Mario Kovacevic. All rights reserved.
//

import Foundation
import UIKit

public class CountriesTableViewCell : UITableViewCell {
    class var identifier: String { return String.className(self) }
    
    @IBOutlet var countryTitle: UILabel!
    @IBOutlet var countryDescription: UILabel!
    @IBOutlet var countrySpecific: UILabel!
}
//
//  CountriesTableViewCell.swift
//  Country
//
//  Created by Mario Kovacevic on 09/05/16.
//

import Foundation
import UIKit

class CountriesTableViewCell : UITableViewCell {
    class var identifier: String { return String.className(self) }
    
    @IBOutlet var countryTitle: UILabel!
    @IBOutlet var countryDescription: UILabel!
    @IBOutlet var countrySpecific: UILabel!
}

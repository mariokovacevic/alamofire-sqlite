//
//  NavigationTableViewCell.swift
//  Country
//
//  Created by Mario Kovacevic on 09/05/16.

import UIKit

class NavigationTableViewCell : UITableViewCell {
    class var identifier: String { return String.className(self) }
    
    override internal func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        self.backgroundColor = UIColor(hex: 0x028090)
        self.textLabel?.textColor = UIColor (hex: 0xe8f1f0)
        self.imageView?.tintColor = UIColor (hex: 0xe8f1f0)
        
        if self.isHighlighted {
            self.backgroundColor = UIColor(hex: 0x004051)
            self.contentView.backgroundColor = UIColor(hex: 0x004051)
        } else {
            self.backgroundColor = UIColor(hex: 0x028090)
            self.contentView.backgroundColor = UIColor(hex: 0x028090)
        }
    }
    
    internal override func setSelected(_ selected: Bool, animated: Bool) {
        if selected == true {
            self.backgroundColor = UIColor(hex: 0x004051)
            self.contentView.backgroundColor = UIColor(hex: 0x004051)
            self.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        } else {
            self.backgroundColor = UIColor(hex: 0x028090)
            self.contentView.backgroundColor = UIColor(hex: 0x028090)
            self.textLabel?.font = UIFont.systemFont(ofSize: 18)
        }

    }
}

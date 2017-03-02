//
//  FloatingTextField.swift
//  Country
//
//  Created by Mario Kovacevic on 26/09/2016.
//

import Foundation
import UIKit
import JVFloatLabeledTextField

extension JVFloatLabeledTextField {
    
    func setImageWithName(imageName:String) {
        self.leftViewMode = UITextFieldViewMode.always
        self.leftView = UIImageView(image: UIImage(named: imageName))
    }
    
    override open func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 0, y: 0, width: 40, height: 40).insetBy(dx: 0, dy: 0) //Change frame according to your needs
    }
}

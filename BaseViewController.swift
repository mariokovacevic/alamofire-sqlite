//
//  BaseViewController.swift
//  AlamofireSQLiteExample
//
//  Created by Mario Kovacevic on 16/10/15.
//  Copyright © 2015 Mario Kovacevic. All rights reserved.
//

import UIKit

class BaseViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func DismissKeyboard(){
        view.endEditing(true)
    }
    
    func goBack() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

}
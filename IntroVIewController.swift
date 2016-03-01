//
//  IntroVIewController.swift.swift
//
//  Created by Mario Kovacevic on 16/10/15.
//  Copyright © 2015 Mario Kovacevic. All rights reserved.
//

import Foundation
import SVProgressHUD

class IntroVIewController : BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.performSegueWithIdentifier("welcomeSeague", sender: nil)
        SVProgressHUD.show()
    }
}
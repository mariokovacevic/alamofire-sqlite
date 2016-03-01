//
//  WelcomeViewController.swift
//
//  Created by Mario Kovacevic on 19/10/15.
//  Copyright © 2015 Mario Kovacevic. All rights reserved.
//

import UIKit
import SVProgressHUD

class WelcomeViewController: BaseViewController {
    
    @IBOutlet var signInBtn: UIButton!
    @IBOutlet var welcomeLbl: UILabel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationPanel()
        
        signInBtn.layer.shadowOpacity = 0.55
        signInBtn.layer.shadowRadius = 5.0
        signInBtn.layer.shadowColor = UIColor.grayColor().CGColor
        signInBtn.layer.shadowOffset = CGSize(width: 0, height: 2.5)
    }
    
    override func viewDidAppear(animated: Bool) {
        SVProgressHUD.dismiss()
    }

    func setNavigationPanel(){
        let nav = self.navigationController?.navigationBar
        nav?.translucent = false
        nav?.barTintColor = UIColor.blackColor()
        nav?.tintColor = UIColor.whiteColor()
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 24))
        imageView.contentMode = .ScaleAspectFit
        
        let image = UIImage(named: "logo")
        imageView.image = image
        
        navigationItem.titleView = imageView
    }
    
    @IBAction func SignIn(sender: AnyObject) {
        SVProgressHUD.show()
        APIHelper.countries { (countries) -> Void in
            CountryDataHelper.importCountries(countries, onCompletion: { () -> Void in
                self.performSegueWithIdentifier("countriesSeague", sender: nil)
            })
        }
    }
}


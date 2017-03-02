//
//  IntroViewController.swift
//  Country
//
//  Created by Mario Kovacevic on 09/05/16.

import Foundation
import SwiftyUserDefaults
import SwiftKeychainWrapper
import EAIntroView

class IntroViewController : BaseViewController, EAIntroDelegate {
    
    @IBOutlet weak var myActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        myActivityIndicator.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Defaults[.autologin] {
            let password: String? = KeychainWrapper.standard.string(forKey: KeychainKeys.password.rawValue)
            if (Defaults.hasKey(.email) && password != nil) {
                APIHelper.login(Defaults[.email], password: password!) { (success) -> Void in
                    if success {
                        self.performSegue(withIdentifier: SegueIdentifier.Main.rawValue, sender: self)
                    } else {
                        self.performSegue(withIdentifier: SegueIdentifier.Login.rawValue, sender: self)
                    }
                }
            }
        } else {
            if (Defaults.hasKey(.email)) {
                self.performSegue(withIdentifier: SegueIdentifier.Login.rawValue, sender: self)
            } else {
                self.showIntroWithCrossDissolve()
            }
        }
    }
    
    /**
     EAIntroView
     
     Highly customizable drop-in solution for introduction views.
     */
    func showIntroWithCrossDissolve(){
        self.myActivityIndicator.stopAnimating()
        self.myActivityIndicator.isHidden = true
        
        let rootView = self.view
        
        let page1: EAIntroPage = EAIntroPage()
        page1.title = "This is page 1"
        page1.desc = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
        page1.titleIconView = UIImageView(image: UIImage(named: "title1"))
        
        let page2: EAIntroPage = EAIntroPage()
        page2.title = "This is page 2"
        page2.desc = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
        page2.titleIconView = UIImageView(image: UIImage(named: "title2"))
        
        let page3: EAIntroPage = EAIntroPage()
        page3.title = "This is page 3"
        page3.desc = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
        page3.titleIconView = UIImageView(image: UIImage(named: "title3"))
        
        let page4: EAIntroPage = EAIntroPage()
        page4.title = "This is page 4"
        page4.desc = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
        page4.titleIconView = UIImageView(image: UIImage(named: "title4"))
        
        let intro: EAIntroView = EAIntroView(frame: rootView!.bounds, andPages: [page1, page2, page3, page4])
        intro.delegate = self
        intro.show(in: rootView, animateDuration: 0.3)
        intro.showSkipButtonOnlyOnLastPage = false
        intro.swipeToExit = false
        intro.skipButtonSideMargin = 50
        
    }
    
    /**
     If skip is pressed or swipe to exit is enabled, this method will get triggered
     */
    func introDidFinish(_ introView: EAIntroView!, wasSkipped: Bool) {
        performSegue(withIdentifier: SegueIdentifier.CreateAccount.rawValue, sender: self)
    }
    
}

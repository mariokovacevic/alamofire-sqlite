//
//  LoginViewController.swift
//  Country
//
//  Created by Mario Kovacevic on 09/05/16.

import Foundation
import SwiftyUserDefaults
import Async
import Toaster
import RNLoadingButton
import JVFloatLabeledTextField

class LoginViewController : BaseViewController, UITextFieldDelegate {
    
    @IBOutlet var inputUsername: JVFloatLabeledTextField!
    @IBOutlet var inputPassword: JVFloatLabeledTextField!
    @IBOutlet var btnSignIn: RNLoadingButton!
    @IBOutlet var btnCreateAccount: UIButton!
    @IBOutlet var forgotPassword: UIButton!
    
    @IBAction func forgotPasswordAction(_ sender: AnyObject) {
        print("forgotPasswordAction", terminator: "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTextFields(inputUsername, placeholder: "Email")
        self.setupTextFields(inputPassword, placeholder: "Password")
        
        self.inputUsername.setImageWithName(imageName: "name")
        self.inputPassword.setImageWithName(imageName: "password")
        
        self.btnSignIn.hideTextWhenLoading = true
        self.btnSignIn.loading = false
        self.btnSignIn.setActivityIndicatorStyle(UIActivityIndicatorViewStyle.white, for: UIControlState.disabled)
        self.btnSignIn.activityIndicatorEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
        self.btnSignIn.backgroundColor = UIColor.clear
        self.btnSignIn.layer.cornerRadius = 5
        self.btnSignIn.layer.borderWidth = 1
        self.btnSignIn.layer.borderColor = UIColor.white.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIView.transition(with: self.view, duration: 0.1, options: .transitionCrossDissolve, animations: {
            self.inputUsername.text = ""
            self.inputPassword.text = ""
            self.navigationController?.navigationBar.isHidden = true
        }) { (success) in
            self.inputUsername.addBottomBorderWithHeight(height: 0.5, color: UIColor.white)
            self.inputPassword.addBottomBorderWithHeight(height: 0.5, color: UIColor.white)
        }
    }
    
    /**
     Sign in button action
     */
    @IBAction func signIn(_ sender: RNLoadingButton) {
        self.startButtonLoader()
        
        Async.main(after: 0.5) { // remove this if you don't want any wait time
            self.validate { () -> Void in
                APIHelper.login(self.inputUsername.text!, password: self.inputPassword.text!) { (success) -> Void in
                    if success {
                        APIHelper.countries { (countries) -> Void in
                            CountryDataHelper.importCountries(countries, onCompletion: { () -> Void in
                                self.performSegue(withIdentifier: SegueIdentifier.Main.rawValue, sender: self)
                                self.stopButtonLoader()
                            })
                        }
                    } else {
                        Toast(text: "Server authentication failed!").show()
                        self.stopButtonLoader()
                    }
                }
            }
        }
    }
    
    /**
     This method will start the loader indicator on Sign In button.
     */
    func startButtonLoader(){
        btnSignIn.isEnabled = false
        btnSignIn.loading = true;
        btnSignIn.hideImageWhenLoading = true
    }
    
    /**
     This method will stop the loader indicator on Sign In button.
     */
    func stopButtonLoader(){
        btnSignIn.isEnabled = true
        btnSignIn.loading = false
        
        if btnSignIn.tag == 3 {
            btnSignIn.isSelected = !btnSignIn.isSelected
        }
    }
    
    /**
     This method will validate all text fields in LoginViewController on Sign In action.
     */
    func validate(_ completed: () -> Void){
        if self.inputUsername.text!.isEmpty {
            self.shake(self.inputUsername, messsage: "Please enter email!")
            self.stopButtonLoader()
        } else {
            if !self.inputUsername.text!.isEmail {
                self.shake(self.inputUsername, messsage: "Please enter valid email!")
                self.stopButtonLoader()
            } else {
                if self.inputPassword.text!.isEmpty {
                    self.shake(self.inputPassword, messsage: "Please enter password!")
                    self.stopButtonLoader()
                } else {
                    if self.inputPassword.text!.isPassword {
                        completed()
                    } else {
                        self.shake(self.inputPassword, messsage: "Password must be at least 8 characters!")
                        self.stopButtonLoader()
                    }
                }
            }
        }
    }
    
    /**
     Move to Create Account view
     */
    @IBAction func createAcount(_ sender: AnyObject) {
        self.performSegue(withIdentifier: SegueIdentifier.CreateAccount.rawValue, sender: self)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
}

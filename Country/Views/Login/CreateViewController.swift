//
//  CreateViewController.swift
//  Country
//
//  Created by Mario Kovacevic on 09/05/16.

import Foundation
import SwiftyUserDefaults
import Toaster
import JVFloatLabeledTextField
import RNLoadingButton
import Async

class CreateViewController : BaseViewController, UITextFieldDelegate {
    
    @IBOutlet var inputFullName: JVFloatLabeledTextField!
    @IBOutlet var inputEmail: JVFloatLabeledTextField!
    @IBOutlet var inputPassword: JVFloatLabeledTextField!
    @IBOutlet var createAccount: RNLoadingButton!
    @IBOutlet var btnSignIn: UIButton!
    @IBOutlet var descriptionMessage: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTextFields(inputFullName, placeholder: "Full Name")
        self.setupTextFields(inputEmail, placeholder: "Email")
        self.setupTextFields(inputPassword, placeholder: "Password")
        
        self.inputFullName.setImageWithName(imageName: "name")
        self.inputEmail.setImageWithName(imageName: "email")
        self.inputPassword.setImageWithName(imageName: "password")

        self.createAccount.backgroundColor = UIColor.clear
        self.createAccount.layer.cornerRadius = 5
        self.createAccount.layer.borderWidth = 1
        self.createAccount.layer.borderColor = UIColor.white.cgColor
        self.createAccount.hideTextWhenLoading = true
        self.createAccount.loading = false
        self.createAccount.setActivityIndicatorStyle(UIActivityIndicatorViewStyle.white, for: UIControlState.disabled)
        self.createAccount.activityIndicatorEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIView.transition(with: self.view, duration: 0.1, options: .transitionCrossDissolve, animations: {
            self.inputFullName.text = ""
            self.inputEmail.text = ""
            self.inputPassword.text = ""
            self.navigationController?.navigationBar.isHidden = true
        }) { (success) in
            self.inputFullName.addBottomBorderWithHeight(height: 0.5, color: UIColor.white)
            self.inputEmail.addBottomBorderWithHeight(height: 0.5, color: UIColor.white)
            self.inputPassword.addBottomBorderWithHeight(height: 0.5, color: UIColor.white)
        }
    }
    
    /**
     Create Account button action.
     */
    @IBAction func createAccount(_ sender: RNLoadingButton) {
        self.startButtonLoader()
        
        Async.main(after: 0.5) { // remove this if you don't want any wait time
            self.validate { () -> Void in
                APIHelper.register(self.inputEmail.text!, password: self.inputPassword.text!, onCompletion: { (success) -> Void in
                    if success == true {
                        APIHelper.countries { (countries) -> Void in
                            CountryDataHelper.importCountries(countries, onCompletion: { () -> Void in
                                self.performSegue(withIdentifier: SegueIdentifier.Main.rawValue, sender: self)
                                self.stopButtonLoader()
                            })
                        }
                    } else {
                        Toast(text: "Registration failed. Please try again!").show()
                        self.stopButtonLoader()
                    }
                })
            }
        }
    }
    
    /**
     This method will start the loader indicator on Sign In button.
     */
    func startButtonLoader(){
        createAccount.isEnabled = false
        createAccount.loading = true;
        createAccount.hideImageWhenLoading = true
    }
    
    /**
     This method will stop the loader indicator on Sign In button.
     */
    func stopButtonLoader(){
        createAccount.isEnabled = true
        createAccount.loading = false
        
        if createAccount.tag == 3 {
            createAccount.isSelected = !createAccount.isSelected
        }
    }
    
    /**
     This method will validate all text fields in CreateViewController on Sign In action.
     */
    func validate(_ completed: () -> Void){
        if self.inputFullName.text!.isEmpty || !self.inputFullName.text!.isFullName {
            self.shake(self.inputFullName, messsage: "Please enter full name!")
            self.stopButtonLoader()
        } else {
            if self.inputEmail.text!.isEmpty {
                self.shake(self.inputEmail, messsage: "Please enter email!")
                self.stopButtonLoader()
            } else {
                if !self.inputEmail.text!.isEmail {
                    self.shake(self.inputEmail, messsage: "Please enter valid email!")
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
    }
    
    /**
     Move to Sign In view
     */
    @IBAction func signIn(_ sender: AnyObject) {
        performSegue(withIdentifier: SegueIdentifier.Login.rawValue, sender: self)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.inputEmail {
            if self.inputEmail.text!.isEmpty {
                self.shake(self.inputEmail, messsage: "Please enter email!")
                self.stopButtonLoader()
            } else {
                if !self.inputEmail.text!.isEmail {
                    self.shake(self.inputEmail, messsage: "Please enter valid email!")
                    self.stopButtonLoader()
                } else {
                    
                }
            }
        }
    }
    
}

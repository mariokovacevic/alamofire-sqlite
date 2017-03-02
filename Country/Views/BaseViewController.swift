//
//  BaseViewController.swift
//  Country
//
//  Created by Mario Kovacevic on 09/05/16.

import Foundation
import Async
import Toaster
import pop
import JVFloatLabeledTextField

class BaseViewController : UIViewController{
        
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BaseViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func viewControllerForPresentingModalView() -> UIViewController {
        return self
    }
    
    /**
     If you want to shake your UITextField, just sent it in this method with message. Message will be shown like Toast.
     
     - Parameter textFieldu:    UITextField to shake.
     - Parameter messsage:      String to show like Toast.
     */
    func shake(_ textField:UITextField, messsage:String) {
        Async.main{
            let shake = POPSpringAnimation(propertyNamed: kPOPLayerPositionX)
            shake?.springBounciness = 20
            shake?.velocity = NSNumber(value: 3000)
            textField.layer.pop_add(shake, forKey: "shakePassword")
        }
        Toast(text: messsage).show()
    }

    //Calls this function when the tap is recognized.
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    func setupTextFields(_ textField:JVFloatLabeledTextField, placeholder:String){
        textField.textColor = UIColor.white
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.floatingLabelTextColor = UIColor.white
        textField.tintColor = UIColor.white
        textField.attributedPlaceholder = NSAttributedString(string:placeholder, attributes:[NSForegroundColorAttributeName: UIColor.white])
    }

}

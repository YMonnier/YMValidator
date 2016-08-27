//
//  ViewController.swift
//  YMValidator
//
//  Created by Ysée MONNIER on 26/08/16.
//  Copyright © 2016 Ysée MONNIER. All rights reserved.
//

import UIKit
import YMValidator

@objc(EmailValidator)
private class EmailValidator: NSObject, YMRulesValidator {
    private var regex: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
}

@objc(PasswordValidator)
class PasswordValidator: NSObject, YMRulesValidator {
    var regex: String = "[A-Z0-9a-z._%+-]{8,}"
}

@objc(CustomValidator)
class CustomValidator: NSObject, YMRulesValidator {
    var regex: String = "[0-9]"
}

class ViewController: UIViewController {
    //MARK: @IBOutlet
    //Email
    @IBOutlet weak var errorEmailLabel: UILabel!
    @IBOutlet weak var inputEmail: YMValidator! {
        didSet {
            self.inputEmail.delegate = self
        }
    }
    
    //Password
    @IBOutlet weak var errorPasswordLabel: UILabel!
    @IBOutlet weak var inputPassword: YMValidator! {
        didSet {
            self.inputPassword.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.errorEmailLabel.text = ""
        self.errorPasswordLabel.text = ""
        
        //Register error labels
        self.inputEmail.setErrorLabel(self.errorEmailLabel)
        self.inputPassword.setErrorLabel(self.errorPasswordLabel)
        
        //
        // Decomment this line to add YMValidator textField programmatically
        //
        //self.addCustomTextField()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func addCustomTextField() {
        //Info label
        let label = UILabel(frame: CGRect(x: 30.0, y: 271.0, width: 540, height: 21))
        label.text = "Custom input:"
        
        //Error label
        let customErrorLabel = UILabel(frame: CGRect(x: 30.0, y: 334.0, width: 540, height: 21))
        customErrorLabel.text = ""
        customErrorLabel.textColor = UIColor.redColor()
        customErrorLabel.textAlignment = .Center
        
        //TextField
        let textField = YMValidator(frame: CGRect(x: 30.0, y: 296.0, width: 540, height: 30), rulesValidator: CustomValidator(), errorMessage: "Only alphanumeric characters are allowed", errorLabel: customErrorLabel)
        
        //
        //Add views
        //
        self.view.addSubview(label)
        self.view.addSubview(customErrorLabel)
        self.view.addSubview(textField)
        
        //
        //Constraints
        //
        // Add your constraints...
    }
    
    @IBAction func validAction(sender: AnyObject) {
        if YMValidator.areValid(self) {
            self.showSimpleAlert(title: "YMValidator", message: "All textFields are valid!!")
        } else {
            self.showSimpleAlert(title: "YMValidator", message: "Wrong")
        }
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

extension UIViewController {
    /**
     Function which display a simple alert view.
     - Parameter viewController: View to adding the alert.
     - Parameter title: Alert title.
     - Parameter message: Alert message.
     - Returns: Void.
     */
    func showSimpleAlert(title title : String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

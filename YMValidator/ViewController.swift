//
//  ViewController.swift
//  YMValidator
//
//  Created by Ysée MONNIER on 26/08/16.
//  Copyright © 2016 Ysée MONNIER. All rights reserved.
//

import UIKit

@objc(EmailValidator)
private class EmailValidator: NSObject, YMRulesValidator {
    private var regex: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
}

@objc(PasswordValidator)
class PasswordValidator: NSObject, YMRulesValidator {
    var regex: String = "[A-Z0-9a-z._%+-]{8,}"
}

class ViewController: UIViewController {
    //MARK: @IBOutlet
    //Email
    @IBOutlet weak var errorEmailLabel: UILabel!
    @IBOutlet weak var inputEmail: YMValidator! {
        didSet {
            self.inputEmail.delegate = self
            self.inputEmail.setErrorLabel(self.errorEmailLabel)
        }
    }
    
    //Password
    @IBOutlet weak var errorPasswordLabel: UILabel!
    @IBOutlet weak var inputPassword: YMValidator! {
        didSet {
            self.inputPassword.delegate = self
            self.inputPassword.setErrorLabel(self.errorPasswordLabel)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.errorEmailLabel.text = ""
        self.errorPasswordLabel.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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

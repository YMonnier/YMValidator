//
//  ViewController.swift
//  YMValidator
//
//  Created by Ysée MONNIER on 26/08/16.
//  Copyright © 2016 Ysée MONNIER. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var inputField: YMValidator! {
        didSet {
            self.inputField.delegate = self
            self.inputField.setErrorLabel(self.errorLabel)
        }
    }
    
    var inputField2: YMValidator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.errorLabel.text = ""
        
        //self.inputField2 = YMValidator(validatorClassName: "", errorMessage: "", errorLabel: <#T##UILabel#>)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func validAction(sender: AnyObject) {
        YMValidator.areValid(self)
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}


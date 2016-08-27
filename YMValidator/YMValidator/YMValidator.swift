//
//  YMValidator.swift
//  YMValidator
//
//  Created by Ysée MONNIER on 26/08/16.
//  Copyright © 2016 Ysée MONNIER. All rights reserved.
//

import UIKit

public protocol YMRulesValidator {
    var regex: String { get set }
}

@objc(EmailValidator)
private class EmailValidator: NSObject, YMRulesValidator {
    private var regex: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
}

@objc(PasswordValidator)
private class PasswordValidator: NSObject, YMRulesValidator {
    private var regex: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
}

private extension NSObject {
    /**
     Reflection function which allows to create swift class from class name.
     - Parameter className: The instance class name.
     - Returns: Nil or Validator instance.
    */
    class func fromClassName(className : String) -> YMRulesValidator? {
        let aClass = NSClassFromString(className) as? NSObject.Type
        if let object = aClass {
            if let validator = object.init() as? YMRulesValidator {
                return validator
            }
        }
        return nil
    }
}

@IBDesignable
public class YMValidator: UITextField {
    
    /// Validator class name.
    @IBInspectable var Class: String = ""
    
    /// Error message.
    @IBInspectable var Error: String = ""
    
    /// Regex string.
    private var regex: String?
    
    /// Error label.
    private var errorLabel: UILabel?
    
    /**
     Returns an object initialized from data in a given unarchiver. 
     `self`, initialized using the data in decoder.
     - Parameter decoder: An unarchiver object.
     - Returns: self, initialized using the data in decoder.
    */
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    /**
     Initializes and returns a newly allocated view object with the specified frame rectangle.
     An initialized view object.
     - Parameter frame: The frame rectangle for the view, measured in points. The origin of the frame is relative to the superview in which you plan to add it. This method uses the frame rectangle to set the center and bounds properties accordingly.
     - Returns:	An initialized view object.
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    convenience init(validatorClassName: String, errorMessage: String, errorLabel: UILabel) {
        self.init()
        self.Class = validatorClassName
        self.Error = errorMessage
        self.errorLabel = errorLabel
    }
    
    private func setupView() {
        self.delegate = self
        self.addTarget(self, action: #selector(YMValidator.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
    }
    
    /**
     Update view.
    */
    internal func updateView(error: Bool = false) {
        if error {
            self.errorLabel?.text = self.Error
        } else {
            self.errorLabel?.text = ""
        }
    }
    
    /**
     Get regex information from the reflection function.
     If data is present set it otherwise nil.
     - Returns: Void.
    */
    private func parseValidator() {
        let Class = NSObject.fromClassName(self.Class)
        self.regex = Class?.regex ?? nil
    }
    
    /**
     Engin function checks if the text is correct depending the rules.
     - Parameter text: Text from textField.
     - Returns: Regex test result.
    */
    private func engin(text: String) -> Bool{
        print(#function)
        print(self.Class)
        print(self.regex)
        if let regex = self.regex {
            let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
            return predicate.evaluateWithObject(text)
            
        }
        return false
    }
    
    /**
     Check if input is valid.
     - Returns: True if 
    */
    internal func isValid() -> Bool {
        let res = self.engin(self.text!)
        self.updateView(!res)
        return res
    }
    
    /**
     Action that triggers when we update text from textField.
     When the text update, we check if the text is valid.
     If that is not the case we will show error message, otherwise not.
     - Parameter textField: Action.
    */
    func textFieldDidChange(textField: UITextField) {
        print(#function)
        if let text = textField.text {
            if !self.engin(text) {
                self.updateView(true)
            } else {
                self.updateView()
            }
        }
    }
    
    /**
     Static function which allows to check all `YMTextField`.
     - Parameter controller: Controller to access YMTextFiel.
     - Returns: True if all inputs are validated, otherwise False.
    */
    class func areValid(controller: UIViewController) -> Bool {
        let subViews = controller.view.subviews
        let customTextFields = subViews.filter { (view) -> Bool in
            view is YMValidator
        }
        var count = 0
        for tf in customTextFields as! [YMValidator] {
            if !tf.isValid() {
                count += 1
            }
        }
        return true
    }
}

extension YMValidator {
    /**
     Set the error label for the current validator.
     - Parameter label: label will set.
    */
    public func setErrorLabel(label: UILabel) {
        self.errorLabel = label
    }
}

extension YMValidator: UITextFieldDelegate {
    //MARK: UITextFieldDelegate
    /**
     Tells the delegate that editing began in the specified text field.
     This method notifies the delegate that the specified text field just became the first responder. Use this method to update state information or perform other tasks. For example, you might use this method to show overlay views that are visible only while editing.
     Implementation of this method by the delegate is optional.
     Parameters textField: The text field in which an editing session began.
    */
    public func textFieldDidBeginEditing(textField: UITextField) {
        self.parseValidator()
    }
}
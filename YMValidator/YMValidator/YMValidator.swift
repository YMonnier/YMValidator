//
//  YMValidator.swift
//  YMValidator
//
//  Created by Ysée MONNIER on 26/08/16.
//  Copyright © 2016 Ysée MONNIER. All rights reserved.
//

import UIKit

@objc(EmailValidator)
private class EmailValidator: NSObject, Validator {
    private var regex: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    //private var error: String = "Incorrect email."
}

private protocol Validator {
    var regex: String { get set }
    //var error: String { get set }
}

private extension NSObject {
    /**
     Reflection function which allows to create swift class from class name.
     - Parameter className: The instance class name.
     - Returns: Nil or Validator instance.
    */
    class func fromClassName(className : String) -> Validator? {
        let aClass = NSClassFromString(className) as? NSObject.Type
        if let object = aClass {
            if let validator = object.init() as? Validator {
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
    
    private func setupView() {
        self.delegate = self
        self.addTarget(self, action: #selector(YMValidator.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
    }
    
    internal func updateView(error: Bool = false) {
        if error {
            self.errorLabel?.text = self.Error
        } else {
            self.errorLabel?.text = ""
        }
    }
    
    private func parseValidator() {
        print(#function + " -- " + self.Class)
        
        let Class = NSObject.fromClassName(self.Class)
        print(Class)
        self.regex = Class?.regex ?? nil
        
    }
    
    internal func validate() -> Bool {
        return self.engin(self.text!)
    }
    
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
    
    func textFieldDidChange(textField: UITextField) {
        print(#function)
        if let text = textField.text {
            if !self.engin(text) {
                self.errorLabel?.text = self.Error
            } else {
                self.errorLabel?.text = ""
            }
        }
    }
    
    class func validates(controller: UIViewController) -> Bool {
        let subViews = controller.view.subviews
        let customTextFields = subViews.filter { (view) -> Bool in
            view is YMValidator
        }
        var count = 0
        for tf in customTextFields as! [YMValidator] {
            if !tf.validate() {
                count += 1
                
            }
        }
        return true
    }
}

extension YMValidator {
    public func setErrorLabel(label: UILabel) {
        self.errorLabel = label
    }
}

extension YMValidator: UITextFieldDelegate {
    //MARK: UITextFieldDelegate
    public func textFieldDidBeginEditing(textField: UITextField) {
        self.parseValidator()
    }
}
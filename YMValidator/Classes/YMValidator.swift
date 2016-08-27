//
//  YMValidator.swift
//  YMValidator
//
//  Created by Ysée MONNIER on 26/08/16.
//  Copyright © 2016 Ysée MONNIER. All rights reserved.
//
//  ***************************************************
//
//  MIT License
//
//  Copyright (c) 2016 Ysee Monnier
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

/**
 `YMRulesValidator` Protocol - string regex.
 */
public protocol YMRulesValidator {
    var regex: String { get set }
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

/**
 Class `YMValidator` allowing to create custom `UITextField`.
 This custom view allows to apply a validator input with a specific regex 
 rules and message error if it is not correct.
 
 
 [GitHub YMValidator](https://github.com/YMonnier/YMValidator)
 
 [Licence MIT](https://github.com/YMonnier/YMValidator/blob/master/README.md)
 
 Contributors:
    * [Ysee Monnier](https://github.com/YMonnier)
 */
@IBDesignable
public class YMValidator: UITextField {
    //MARK: @IBInspectable
    /// Validator class name.
    @IBInspectable var className: String? = nil
    
    /// Error message.
    @IBInspectable var errorMessage: String? = nil
    
    //MARK: Variable
    /// Rule validator
    private var rulesValidator: YMRulesValidator? = nil
    
    /// Regex string.
    private var regex: String? = nil
    
    /// Error label.
    private var errorLabel: UILabel? = nil
    
    //MARK: Setup
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
    private override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    /**
     Initializes and returns a newlt allocated `YMValidator` object.
     - Parameter validatorClassName: Class name of validator. This class name is used for reflection function(`NSClassFromString`).
     - Parameter errorMessage: Error message string. This will appear when the text does not follow the rules(`regex` from `YMRulesValidator` protocol).
     - Parameter errorLabel: Label to view the error message.
    */
    public convenience init(frame: CGRect, validatorClassName: String, errorMessage: String, errorLabel: UILabel) {
        self.init(frame: frame, errorMessage: errorMessage, errorLabel: errorLabel)
        self.className = validatorClassName
    }
    
    /**
     Initializes and returns a newlt allocated `YMValidator` object.
     - Parameter rulesValidator: An instance of `YMRulesValodator which contains the regex rule.
     - Parameter errorMessage: Error message string. This will appear when the text does not follow the rules(`regex` from `YMRulesValidator` protocol).
     - Parameter errorLabel: Label to view the error message.
     */
    public convenience init(frame: CGRect, rulesValidator: YMRulesValidator, errorMessage: String, errorLabel: UILabel) {
        self.init(frame: frame, errorMessage: errorMessage, errorLabel: errorLabel)
        self.rulesValidator = rulesValidator
    }
    
    /**
     Private initializes and returns a newlt allocated `YMValidator` object.
     - Parameter errorMessage: Error message string. This will appear when the text does not follow the rules(`regex` from `YMRulesValidator` protocol).
     - Parameter errorLabel: Label to view the error message.
     */
    private convenience init(frame: CGRect, errorMessage: String, errorLabel: UILabel) {
        self.init(frame: frame)
        self.errorMessage = errorMessage
        self.errorLabel = errorLabel
    }
    
    /**
     Setup the current view.
        * Add EditingChanged event to the current textField.
        * Add EditingDidBegin event to the current textField.
    */
    private func setupView() {
        self.borderStyle = .RoundedRect
        self.addTarget(self, action: #selector(YMValidator.textFieldDidChange(_:)), forControlEvents: .EditingChanged)
        self.addTarget(self, action: #selector(YMValidator.textFieldDidBeginEditing(_:)), forControlEvents: .EditingDidBegin)
    }
    
    /**
     Update view.
    */
    /**
     Update the view depending the rules validator result.
     If error equals true, no error otherwise we show error message.
     - Parameter error: rules validator result(see `engin` function).
    */
    internal func updateView(error: Bool = false) {
        if self.text == "" {
            self.errorLabel?.text = "Required field."
            return
        }
        if !error {
            self.errorLabel?.text = self.errorMessage
        } else {
            self.errorLabel?.text = ""
        }
    }
    
    //MARK: Usefull functions.
    
    /**
     Get regex information from the reflection function.
     If data is present set it otherwise nil.
     - Returns: Void.
    */
    private func parseRulesValidator() {
        print(#function)
        if let className = self.className {
            let Class = NSObject.fromClassName(className)
            print(Class)
            self.regex = Class?.regex ?? nil
        } else if let rules = self.rulesValidator {
            self.regex = rules.regex
        }
    }
    
    /**
     Engin function checks if the text is correct depending the rules and 
     update the textField view if neccessary.
    */
    private func engin() -> Bool {
        print(#function)
        print(self.className)
        print(self.regex)
        var res: Bool = false
        if let regex = self.regex {
            let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
            res = predicate.evaluateWithObject(text)
            
        }
        self.updateView(res)
        return res
    }
    
    /**
     Check if input is valid.
     - Returns: True if 
    */
    internal func isValid() -> Bool {
        let res = self.engin()
        self.updateView(res)
        return res
    }
}

extension YMValidator {
    /**
     Static function which allows to check all `YMTextField`.
     - Parameter controller: Controller to access YMTextFiel.
     - Returns: True if all inputs are validated, otherwise False.
     */
    public static func areValid(controller: UIViewController) -> Bool {
        let subViews = controller.view.subviews
        let customTextFields = subViews.filter { (view) -> Bool in
            view is YMValidator
        }
        var count = 0
        for tf in customTextFields as! [YMValidator] {
            if tf.isValid() {
                count += 1
            }
        }
        return count == customTextFields.count
    }
}

extension YMValidator {
    //MARK: Setter
    /**
     Set the error label for the current validator.
     - Parameter label: label will set.
    */
    public func setErrorLabel(label: UILabel) {
        self.errorLabel = label
    }
    
    /**
     Set the rules validator for the current validator.
     - Parameter rules: rules will set.
     */
    public func setErrMessage(message: String) {
        self.errorMessage = message
    }
    
    /**
     Set the rules validator for the current validator.
     - Parameter rules: rules will set.
    */
    public func setRulesValidator(rules: YMRulesValidator) {
        self.rulesValidator = rules
    }
}

extension YMValidator {
    //MARK: UITextField Actions
    /**
     Action that triggers when we update text from textField.
     When the text update, we check if the text is valid.
     If that is not the case we will show error message, otherwise not.
     - Parameter textField: Action.
     */
    func textFieldDidChange(textField: UITextField) {
        print(#function)
        self.engin()
    }
    
    /**
     Action that editing began in the specified text field.
     When the user start to edit the textField, we parse the rules validator from 
     @IBInspectable variable or `YMRulesValidator` object.
     
     Parameters textField: The text field in which an editing session began.
    */
    public func textFieldDidBeginEditing(textField: UITextField) {
        print(#function)
        self.parseRulesValidator()
    }
}
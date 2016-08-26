//
//  YMValidator.swift
//  YMValidator
//
//  Created by Ysée MONNIER on 26/08/16.
//  Copyright © 2016 Ysée MONNIER. All rights reserved.
//

import UIKit

private class EmailValidator: Validator {
    private var regex: String! = ""
}

private protocol Validator {
    var regex: String! { get set }
}

private extension NSObject {
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
class YMValidator: UITextField {
    
    /// Validator class name.
    @IBInspectable var Class: String = "" {
        didSet {
            self.engin()
        }
    }
    
    /// Regex string.
    private var regex: String?
    
    /**
     Returns an object initialized from data in a given unarchiver. 
     `self`, initialized using the data in decoder.
     - Parameter decoder: An unarchiver object.
     - Returns: self, initialized using the data in decoder.
    */
    required init?(coder aDecoder: NSCoder) {
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
        self.addTarget(self, action: #selector(YMValidator.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
    }
    
    private func setupValidator() {
        let Class = NSObject.fromClassName(self.Class)
        self.regex = Class?.regex ?? nil
    }
    
    func engin() {
        
    }
    
    func textFieldDidChange(textField: UITextField) {
        print(#function)
        if let text = textField.text {
            
        }
    }
}
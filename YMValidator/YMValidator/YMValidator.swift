//
//  YMValidator.swift
//  YMValidator
//
//  Created by Ysée MONNIER on 26/08/16.
//  Copyright © 2016 Ysée MONNIER. All rights reserved.
//

import UIKit

private protocol Validator {
    var regex: String? { get set }
}

private extension NSObject {
    class func fromClassName(className : String) -> Validator {
        let aClass = NSClassFromString(className) as! NSObject.Type
        return aClass.init() as! Validator
    }
}

@IBDesignable
class YMValidator: UITextField {
    @IBInspectable var validator: String = "" {
        didSet {
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func engin() {
        
    }
}
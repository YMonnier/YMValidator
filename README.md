# YMValidator

![Platform iOS](https://img.shields.io/badge/platform-iOS-blue.svg)
[![Swift 2.2](https://img.shields.io/badge/Swift-2.2-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![License](https://img.shields.io/cocoapods/l/Ouroboros.svg?style=flat)](https://github.com/YMonnier/YMValidator/blob/master/LICENSE)

TextField Validation library for Swift (@IBDesignable & Programmatically)

Usage
-----

First create your custom validator class.
The class has to have `@objc` declaration, conform to `YMRulesValidator` protocol and `NSObject` .
```
@objc(EmailValidator)
class EmailValidator: NSObject, YMRulesValidator {
    var regex: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
}
```


##### With Storyboard

1. Add your TextField
2. Set the **custom class** `YMValidator`
3. On **attributs inspector**, set `Class Name` and `Error Message`

![CustomClass](https://raw.githubusercontent.com/YMonnier/YMValidator/master/Resources/CustomClass.png)
![Inspector](https://raw.githubusercontent.com/YMonnier/YMValidator/master/Resources/Inspector.png)

4. Set the error label to `YMValidator`
```
@IBOutlet weak var errorEmailLabel: UILabel!
@IBOutlet weak var inputEmail: YMValidator! {
    didSet {
        self.inputEmail.setErrorLabel(self.errorEmailLabel)
    }
}
```

##### Programmatically

```
//ViewController.swift
let textField = YMValidator(frame: CGRect(x: 30.0, y: 296.0, width: 540, height: 30), rulesValidator: CustomValidator(), errorMessage: "Only alphanumeric characters are allowed", errorLabel: customErrorLabel)
self.view.addSubview(textField)
```

##### Finally
You can check if all inputs are valid with this static function.

```
YMValidator.areValid(self)
```

Example
-------

[Download]() and run the example for more details.

License
-------
YMValidator is available under the MIT license. See the [LICENSE](https://github.com/YMonnier/ProBill/blob/master/LICENSE) file for more info.

Contributors
------------
[@YMonnier](https://github.com/YMonnier)

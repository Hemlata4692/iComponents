//
//  iTextfieldExtension.swift
//  iComponents
//
//  Created by Rahul Panchal on 31/01/17.
//  Copyright © 2017 Ranosys. All rights reserved.
//

import Foundation
import UIKit

let kDefaultBottomBorderWidth:CGFloat = 0.5
let kDefaultBottomBorderColor = UIColor.darkGray
let kFloatingLabelHeight:CGFloat = 21.0
let kFloatingLabelAnimationDuration = 0.3
let kDefaultFloatingLabelTextColor = UIColor.gray
let kDefaultFloatingLabelPadding:CGFloat = 0.0

public extension UITextField {
    
    private struct AssociatedKey {
        static var floatingLabelColor    = "floatingLabelColor"
        static var floatingLabelXPadding = "floatingLabelXPadding"
        static var floatingLabelYPadding = "floatingLabelYPadding"
    }
    
    /**
     * Add color to placeholder text of the textfield.
     * Defaults is gray color
     */
    var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSForegroundColorAttributeName: newValue!])
        }
    }
    
    /**
     * Text color of the floating label upon presentation.
     * Defaults is gray color
     */
    var floatingLabelTextColor: UIColor? {
        get {
            guard (objc_getAssociatedObject(self, &AssociatedKey.floatingLabelColor) as? UIColor != nil) else {
                return kDefaultFloatingLabelTextColor
            }
            return objc_getAssociatedObject(self, &AssociatedKey.floatingLabelColor) as? UIColor
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.floatingLabelColor, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /**
     * Padding to be applied to the x coordinate of the floating label upon presentation.
     * Defaults to zero
     */
    var floatingLabelXPadding: CGFloat {
        get {
            guard (objc_getAssociatedObject(self, &AssociatedKey.floatingLabelXPadding) != nil) else {
                return kDefaultFloatingLabelPadding
            }
            return objc_getAssociatedObject(self, &AssociatedKey.floatingLabelXPadding) as! CGFloat
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.floatingLabelXPadding, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /**
     * Padding to be applied to the y coordinate of the floating label upon presentation.
     * Defaults to zero.
     */
    var floatingLabelYPadding: CGFloat {
        get {
            guard (objc_getAssociatedObject(self, &AssociatedKey.floatingLabelYPadding) != nil) else {
                return kDefaultFloatingLabelPadding
            }
            return objc_getAssociatedObject(self, &AssociatedKey.floatingLabelYPadding) as! CGFloat
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.floatingLabelYPadding, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /**
     *  Sets the textfield left padding
     *
     *  @param amount The value is used to add padding at the left side of the textfield.
     */
    func setLeftPaddingPoints(amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    /**
     *  Sets the textfield left padding
     *
     *  @param amount The value is used to add padding at the right side of the textfield.
     */
    func setRightPaddingPoints(amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    /**
     *  Adds a border to the bottom of the textfield
     *
     *  @param width The value is optional and used to apply thickness to border and default value is 0.5.
     *  @param borderColor The value is optional and used to apply color to border and default value is gray color.
     */
    func addBottomBorder(width:CGFloat? = kDefaultBottomBorderWidth, borderColor:UIColor? = kDefaultBottomBorderColor) {
        let border = CALayer()
        border.borderColor = borderColor!.cgColor
        border.frame = CGRect(x: 0.0, y: self.bounds.size.height - width!, width:  self.bounds.size.width, height: self.bounds.size.height)
        border.borderWidth = width!
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    /**
     *  Sets floating label to the textfield
     *
     */
    func setTextFieldWithFloatingLabel() {
        let floatingLabel:UILabel = UILabel()
        floatingLabel.text = self.placeholder
        floatingLabel.adjustsFontSizeToFitWidth = true
        floatingLabel.font = UIFont(name: (self.font?.fontName)!, size: (self.font?.pointSize)! * 0.7)
        floatingLabel.textAlignment = .left
        floatingLabel.textColor = floatingLabelTextColor
        floatingLabel.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: kFloatingLabelHeight)
        floatingLabel.alpha = 0.0
        self.superview?.addSubview(floatingLabel)
        self.addTarget(self, action: #selector(self.hideShowFloatingLabel), for: UIControlEvents.editingChanged)
    }
    
    internal func hideShowFloatingLabel() {
        if(self.text!.characters.count > 0)
        {
            for subview in (self.superview?.subviews)!
            {
                if subview.isKind(of: UILabel.self)
                {
                    let label:UILabel = subview as! UILabel
                    if (label.text == self.placeholder)
                    {
                        label.textColor = floatingLabelTextColor
                        UIView.animate(withDuration: kFloatingLabelAnimationDuration, delay: 0.0, options: [.beginFromCurrentState, .curveEaseOut], animations: {
                            label.alpha = 1.0
                            label.frame = CGRect(x: (self.frame.origin.x + self.floatingLabelXPadding), y:
                                (self.frame.origin.y + self.floatingLabelYPadding) - 2, width:
                                label.frame.size.width, height:
                                label.frame.size.height);
                        }, completion: nil)
                    }
                }
            }
        }
        else
        {
            let trimmedText = self.text!.trimmingCharacters(in: NSCharacterSet.whitespaces)
            if(trimmedText == "")
            {
                for subview in (self.superview?.subviews)!
                {
                    if subview.isKind(of: UILabel.self)
                    {
                        let label:UILabel = subview as! UILabel
                        if (label.text == self.placeholder)
                        {
                            UIView.animate(withDuration: kFloatingLabelAnimationDuration, delay: 0.0, options: [.beginFromCurrentState, .curveEaseIn], animations: {
                                label.alpha = 0.0
                                label.frame = CGRect(x: (self.frame.origin.x + self.floatingLabelXPadding), y:
                                    (self.frame.origin.y + self.floatingLabelYPadding), width:
                                    label.frame.size.width, height:
                                    label.frame.size.height);
                            }, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    /**
     *  Checks password validation for textfield
     *  @param regexRule The value is optional and has a regular expression which will be used to validate the textfield.
     *  if password is correct then it returns true otherwise false.
     *  Default Password Rule: 8 characters. One uppercase.
     */
    func isValidPassword(regexRule:String?) -> Bool {
        // Alternative Regexes
        
        // 8 characters. One uppercase. One Lowercase. One number.
        // static let regex = "^(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[a-z]).{8,}$"
        //
        // no length. One uppercase. One lowercae. One number.
        // static let regex = "^(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[a-z]).*?$"
        
        let trimmedText = self.text!.trimmingCharacters(in: NSCharacterSet.whitespaces)
        let passwordRegEx = regexRule != nil ? regexRule : "^(?=.*?[A-Z]).{8,}$"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx!)
        return passwordTest.evaluate(with: trimmedText)
    }
    
    /**
     *  Checks email validation for textfield
     *  if email is correct then it returns true otherwise false.
     */
    func isValidEmail() -> Bool {
        let trimmedText = self.text!.trimmingCharacters(in: NSCharacterSet.whitespaces)
        let regexRule = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", regexRule)
        return emailTest.evaluate(with: trimmedText)
    }
    
    /**
     *  Checks phone number validation for textfield
     *  @param regexRule The value is optional and has a regular expression which will be used to validate the textfield.
     *  if phone number is correct then it returns true otherwise false.
     *  Default PhoneNumber Rule: 10 digits.
     */
    func isValidPhoneNumber(regexRule:String?) -> Bool {
        let trimmedText = self.text!.trimmingCharacters(in: NSCharacterSet.whitespaces)
        let phoneNumberRegex = regexRule != nil ? regexRule : "^\\d{10}$"
        let phoneNumberTest = NSPredicate(format:"SELF MATCHES %@", phoneNumberRegex!)
        return phoneNumberTest.evaluate(with: trimmedText)
    }
    
    /**
     *  Checks ZipCode validation for textfield
     *  @param regexRule The value is optional and has a regular expression which will be used to validate the textfield.
     *  if zip code is correct then it returns true otherwise false.
     *  Default Zip Code Rule: 5 digits.
     */
    func isValidZipCode(regexRule:String?) -> Bool {
        let trimmedText = self.text!.trimmingCharacters(in: NSCharacterSet.whitespaces)
        let zipCodeRegex = regexRule != nil ? regexRule : "\\d{5}"
        let zipCodeTest = NSPredicate(format:"SELF MATCHES %@", zipCodeRegex!)
        return zipCodeTest.evaluate(with: trimmedText)
    }
}

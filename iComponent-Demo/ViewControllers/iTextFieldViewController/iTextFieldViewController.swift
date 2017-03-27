//
//  iTextFieldViewController.swift
//  iComponents
//
//  Created by Ranosys Technologies on 20/03/17.
//  Copyright © 2017 Ranosys. All rights reserved.
//

import UIKit

class iTextFieldViewController: iComponentsViewController,UITextFieldDelegate {
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    
    // MARK:
    // MARK: View Methods
    func actionBackButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(text: "iTextField")
        
        let backBtn =  addBackBtn()
        backBtn.addTarget(self, action: #selector(actionBackButton), for: .touchUpInside)
        
        // add attributes to textfield
        addCustomAttributesToTextField(textField: firstNameTextField)
        addCustomAttributesToTextField(textField: lastNameTextField)
        addCustomAttributesToTextField(textField: emailAddressTextField)
        addCustomAttributesToTextField(textField: mobileNumberTextField)
        addCustomAttributesToTextField(textField: passwordTextField)
        addCustomAttributesToTextField(textField: confirmPasswordTextField)
    }
    
    func addCustomAttributesToTextField(textField: UITextField) {
        // adding color to placeholder
        textField.placeHolderColor = UIColor.red
        
        // adding bottom border
        textField.addBottomBorder(width: 1.0, borderColor: UIColor.red)
        
        // adding bottom border
        textField.setLeftPaddingPoints(amount: 5.0)
        
        // adding floating label textfield
        textField.setTextFieldWithFloatingLabel()
        
        // adding color to placeholder
        textField.floatingLabelTextColor = UIColor.blue
        
        // adding x Padding to floating label
        textField.floatingLabelXPadding = 5.0
        
        // adding y Padding to floating label
        textField.floatingLabelYPadding = -10.0
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

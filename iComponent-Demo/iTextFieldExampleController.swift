//
//  iTextFieldExampleController.swift
//  iComponents
//
//  Created by Rahul Panchal on 08/02/17.
//  Copyright © 2017 Ranosys. All rights reserved.
//

import UIKit
import iComponents

class iTextFieldExampleController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  ICTextViewPlaceHolder.swift
//  iComponents
//
//  Created by Roshan Singh Bisht on 30/03/17.
//  Copyright © 2017 Ranosys. All rights reserved.
//

import UIKit

class ICTextViewPlaceHolder: HomeViewController {
    
    func actionBackButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // To use this class just give the class f text view to Rtpl_textViewPlaceholderLabel Class and all set u can control its properties dynamically anytime.
        
        let backBtn =  addBackBtn()
        backBtn.addTarget(self, action: #selector(actionBackButton), for: .touchUpInside)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

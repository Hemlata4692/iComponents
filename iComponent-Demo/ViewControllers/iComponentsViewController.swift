//
//  iComponentsViewController.swift
//  iComponents
//
//  Created by Ranosys Technologies on 20/03/17.
//  Copyright © 2017 Ranosys. All rights reserved.
//

import UIKit
import iComponents

class iComponentsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    public func setNavigationTitle(text: String) {
        self.navigationItem.title = text
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont.systemFont(ofSize: 20)]
        self.navigationController?.navigationBar.barTintColor = UIColor.white
    }

    public func addBackBtn() -> UIButton {
        let leftBarBtn = UIButton()
        leftBarBtn.setImage(UIImage(named: "back"), for: .normal)
        leftBarBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftBarBtn.setTitleColor(UIColor.black, for: .normal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView:  leftBarBtn)
        return leftBarBtn
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

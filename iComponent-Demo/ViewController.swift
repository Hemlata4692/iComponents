//
//  ViewController.swift
//  iComponent-Demo
//
//  Created by Jogendar Singh on 06/02/17.
//  Copyright © 2017 Ranosys. All rights reserved.
//

import UIKit
import iComponents

class ViewController: UIViewController, IlocationPermissionDelegate {


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Code Snippet to access Reachability shared instance
        // Reachability.sharedInstance
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        IlocationPermission.sharedInstance.locationDelegate = self
        IlocationPermission.sharedInstance.getLocation(target: self)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func zoomInOut(_ sender: Any) {
        UIView().funcZoomInOut(image: UIImage(named:"download")!)
    }
    
    public func updateLocation(locationsArray: NSArray) {
        print("Current Location Cordinate: \(locationsArray.lastObject!)")
        IlocationPermission.sharedInstance.stopLocation()
    }
}


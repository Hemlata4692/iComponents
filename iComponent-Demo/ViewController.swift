//
//  ViewController.swift
//  iComponent-Demo
//
//  Created by Jogendar Singh on 06/02/17.
//  Copyright © 2017 Ranosys. All rights reserved.
//

import UIKit
import iComponents

private let cancel                                  = "Cancel"
private let settings                                = "Settings"
private let locationServiceAlertTittle              = "Location Service Disabled"
private let locationServiceAlertMessage: String     = "Your location service is not enabled for the app. \nTo enable go Setting > your App > Location then enable it."

class ViewController: UIViewController, iLocationPermissionDelegate {


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Code Snippet to access Reachability shared instance
        // Reachability.sharedInstance
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /// Get curren location
        guard iLocationPermission.sharedInstance.checkLocationPermissions(delegate: self) else {
            showAlertForEnableLocations()
            return
        }
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
        iLocationPermission.sharedInstance.stopLocation()
    }
    
    /**
     Show alert when location manager's service status/authorization status is disable.
     */
    func showAlertForEnableLocations() {
        
        let alert = UIAlertController.init(title: locationServiceAlertTittle, message: locationServiceAlertMessage, preferredStyle: .alert)
        let settingsButton = UIAlertAction.init(title: settings, style: .default) { action -> Void in
            let urlObj = URL(string:"App-Prefs:root=Privacy&path=LOCATION")!
            if UIApplication.shared.canOpenURL(urlObj) {
                UIApplication.shared.openURL(urlObj)
            }
            
        }
        let cancelButton = UIAlertAction.init(title: cancel, style: .cancel, handler: nil)
        alert.addAction(settingsButton)
        alert.addAction(cancelButton)
        self.present(alert, animated: true, completion: nil)
    }
    

}


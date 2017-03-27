//
//  IlocationPermission.swift
//  imReporter
//
//  Created by Kritika Middha on 16/03/17.
//  Copyright © 2017 Ranosys. All rights reserved.
//

import UIKit
import CoreLocation

private let cancel                                  = "Cancel"
private let settings                                = "Settings"
private let locationServiceAlertTittle              = "Location Service Disabled"
private let locationServiceAlertMessage: String     = "Your location service is not enabled for the app. \nTo enable go Setting > %@ > Location, then enable it."

/**
 IlocationPermission class is for get current location of user.
 */


public class IlocationPermission: NSObject {
    
    /// Location manager variable.
    var locationManager : CLLocationManager?
    
    /// Instance variable of "IlocationPermission" class.
    public static let sharedInstance = IlocationPermission.init()
    var locationManagerClosures: [((_ userLocationArray: NSArray) -> ())] = []
    
    /**
     initialization and setup of location
     */
    override init() {
        super.init()
        
        self.locationManager = CLLocationManager()
        guard let locationManager = self.locationManager else {
            return
        }
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 200
        locationManager.delegate = self
    }
    
    /**
     Check location manager's service status and authorization status.

     - parameter delegate: refrence of view controller for IlocationPermissionDelegate delegate object .
     */
    public func getCurrentLocation(target: UIViewController, userLocationClosure: @escaping ((_ userLocationArray: NSArray) -> ())) {
        self.locationManagerClosures.append(userLocationClosure)
        
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .restricted, .denied:
                showAlertForEnableLocations(target: target)
                break
                
            case .authorizedAlways, .authorizedWhenInUse:
                DispatchQueue.main.async {
                    self.locationManager?.startUpdatingLocation()
                }
                break
            default: break
            }
        } else {
            showAlertForEnableLocations(target: target)
        }
    }
    
    /**
     Show alert when location manager's service status/authorization status is disable.
     */
    func showAlertForEnableLocations(target: UIViewController) {
        let appName = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String

        let alert = UIAlertController.init(title: locationServiceAlertTittle, message: String(format: locationServiceAlertMessage,appName), preferredStyle: .alert)
        let settingsButton = UIAlertAction.init(title: settings, style: .default) { action -> Void in
            let urlObj = URL(string:"App-Prefs:root=Privacy&path=LOCATION")!
            if UIApplication.shared.canOpenURL(urlObj) {
                UIApplication.shared.openURL(urlObj)
            }
        }
        let cancelButton = UIAlertAction.init(title: cancel, style: .cancel, handler: nil)
        alert.addAction(settingsButton)
        alert.addAction(cancelButton)
        target.present(alert, animated: true, completion: nil)
    }
    
    /**
     Stop update location.
     */
    public func stopLocation() {
        locationManager?.stopUpdatingLocation()
    }
}

extension IlocationPermission: CLLocationManagerDelegate {

    // CLLocation Manager delegates
    /**
     Tells the delegate that new location data is available.
     
     - parameter manager: The location manager object that generated the update event..
     - parameter locations: An array of CLLocation objects containing the location data. This array always contains at least one object representing the current location.
     */
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let tempClosures = self.locationManagerClosures
        for closure in tempClosures {
            closure(locations as NSArray)
        }
        self.locationManagerClosures = []
    }
    
    /**
     Tells the delegate that the authorization status for the application changed.
     
     - parameter manager: The location manager object that generated the update event..
     - parameter locations: The new authorization status for the application.
     */
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted: fallthrough
        case .denied: fallthrough
        case .notDetermined:
            self.stopLocation()
            break
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            break
        }
    }
    
    /**
     Tells the delegate that the location manager was unable to retrieve a location value.
     
     - parameter manager: The location manager object that generated the update event..
     - parameter locations: The error object containing the reason the location or heading could not be retrieved.
     */
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.stopLocation()
    }
    
}


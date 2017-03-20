//
//  iLocationPermission.swift
//  imReporter
//
//  Created by Kritika Middha on 16/03/17.
//  Copyright © 2017 Ranosys. All rights reserved.
//

import UIKit
import CoreLocation


public protocol iLocationPermissionDelegate {
    /**
     Get current location array when it retrived.
     
     - parameter locationsArray: An array containing the location data of all locations captured.
     */
    func updateLocation(locationsArray: NSArray)
}

public class iLocationPermission: NSObject, CLLocationManagerDelegate {
    
    /// Location manager variable.
    var kLocationManager : CLLocationManager?
    
    ///  Delegate variable of "iLocationPermissionDelegate" protocol.
    var locationDelegate : iLocationPermissionDelegate?
    
    /// Instance variable of "iLocationPermission" class.
    public static let sharedInstance = iLocationPermission.init()
    
    
    /**
     initialization and setup of location
     */
    override init() {
        super.init()
        
        self.kLocationManager = CLLocationManager()
        guard let locationManager = self.kLocationManager else {
            return
        }
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 200
        locationManager.delegate = self
    }
    
    /**
     Check location manager's service status and authorization status.

     - parameter delegate: refrence of view controller for iLocationPermissionDelegate delegate object .
     */
    public func checkLocationPermissions(delegate: iLocationPermissionDelegate) -> Bool {
        var status: Bool = false
        
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                status = false
                break
                
            case .authorizedAlways, .authorizedWhenInUse:
                locationDelegate = delegate
                DispatchQueue.main.async {
                    self.kLocationManager?.startUpdatingLocation()
                }
                status = true
                break
            }
        } else {
            status = false
        }
        return status
    }
    
    /**
     Stop update location.
     */
   public func stopLocation() {
        kLocationManager?.startUpdatingLocation()
    }
    
    
    //MARK:- CLLocation Manager delegates
    /**
     Tells the delegate that new location data is available.
     
     - parameter manager: The location manager object that generated the update event..
     - parameter locations: An array of CLLocation objects containing the location data. This array always contains at least one object representing the current location.
     */
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationDelegate?.updateLocation(locationsArray: locations as NSArray)
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


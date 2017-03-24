//
//  MapViewController.swift
//  iComponents
//
//  Created by Roshan Singh Bisht on 23/03/17.
//  Copyright © 2017 Ranosys. All rights reserved.
//

import UIKit
import iComponents
import MapKit

class MapViewController: UIViewController {
    @IBOutlet weak var myMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let location : String = ("\(26.9124),\(75.78731)")
        let location2: String = ("\(28.70412),\(77.1025)")
        
        let locationArray: NSArray = [location,location2]
        let objeArray : NSArray = ["true",locationArray]
        let keyArray : NSArray = ["sensor","waypoints"]
            let dict = NSDictionary(objects: objeArray as! [Any], forKeys: keyArray as! [NSString])
        
        
        iMapView().setDirectionsQuery(dict, with: #selector(addDirections), withDelegate: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func addDirections(_ jsonData : NSDictionary) -> Void {
        if !(jsonData["status"] as! String == "ZERO_RESULTS") {
            var routes: [String : Any] = (jsonData["routes"] as! NSArray).firstObject as! [String : Any]
            var route: [String: Any] = routes["overview_polyline"] as! [String: Any]
            var overview_route: String? = route["points"] as? String
        
        } else {
        
        }
    }
}

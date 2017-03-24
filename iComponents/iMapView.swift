//
//  iMapView.swift
//  iComponents
//
//  Created by Roshan Singh Bisht on 23/03/17.
//  Copyright © 2017 Ranosys. All rights reserved.
//

import UIKit

 public class iMapView: NSObject {
    var sensor: Bool = false
    var alternatives: Bool = false
    var directionsURL: URL?
    var waypoints = [Any]()
    let kMDDirectionsURL: String = "https://maps.googleapis.com/maps/api/directions/json?"
    
    
   public func setDirectionsQuery(_ query: NSDictionary, with selector: Selector, withDelegate delegate: Any) {
        var waypoints: [Any]? = (query["waypoints"] as? [Any])
        let origin = (waypoints![0] as! String)
        let waypointCount: Int? = waypoints?.count
        let destinationPos: Int = waypointCount! - 1
        let destination = waypoints![destinationPos] as! String
        let sensor = (query["sensor"] as! String)
        var url: String = "\(kMDDirectionsURL)origin=\(origin)&destination=\(destination)&sensor=\(sensor)"
        if waypointCount! > 2 {
            url += "&waypoints=optimize:true"
            let wpCount: Int = waypointCount! - 2
            for i in 1..<wpCount {
                url += "|"
                url += (waypoints?[i] as AnyObject) as! String
            }
        }
        url = url.addingPercentEscapes(using: String.Encoding.ascii)!
        directionsURL = URL(string: url)
        self.retrieveDirections(selector, withDelegate: delegate)
    }
    
    func retrieveDirections(_ selector: Selector, withDelegate delegate: Any) {
        
        DispatchQueue.main.async(execute: {() -> Void in
            let dataTemp = try! Data.init(contentsOf: self.directionsURL!)
            self.fetchedData(dataTemp, with: selector, withDelegate: delegate)
        })
    }
    
    func fetchedData(_ data: Data, with selector: Selector, withDelegate delegate: Any) {
        
        let jsonResult = try? JSONSerialization.jsonObject(with: data, options:[]) as! [String:Any]
        _ = (delegate as AnyObject).perform(selector, with: jsonResult)
    }
    
    func addDirections(_ data : NSDictionary) -> (Void) {
        
    }
}

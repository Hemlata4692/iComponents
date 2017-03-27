//
//  HomeViewController.swift
//  iComponents
//
//  Created by Ranosys Technologies on 20/03/17.
//  Copyright © 2017 Ranosys. All rights reserved.
//

import UIKit
import CoreLocation
import iComponents

class HomeViewController: iComponentsViewController {

    @IBOutlet weak var componentsTableView: UITableView!
    
    let componentsArray: [String] = ["Reachability Example","iTextField Example","Zoom In/Out Example","App Tutorial Example","iLocation Example","DLog Example"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return componentsArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ComponentTableCell", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = componentsArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.checkNetwok()
            
        case 1:
            let vc = (self.storyboard?.instantiateViewController(withIdentifier: "text_field_vc"))!
            let navigationController = UINavigationController(rootViewController: vc)
            self.present(navigationController, animated: true, completion: nil)
            
        case 2:
            UIView().funcZoomInOut(image: UIImage(named:"download")!)

        case 3:
            let vc = (self.storyboard?.instantiateViewController(withIdentifier: "tutorial_vc"))!
            let navigationController = UINavigationController(rootViewController: vc)
            self.present(navigationController, animated: true, completion: nil)

        case 4:
            IlocationPermission.sharedInstance.getCurrentLocation(target: self, userLocationClosure: { (userLocationArray: NSArray) in
                let cllocation = userLocationArray.lastObject as! CLLocation
                let latitude = cllocation.coordinate.latitude
                let longitude = cllocation.coordinate.longitude
                
                let alert = UIAlertController.init(title: "Current Location :", message: "latitude \(latitude) \n longitude \(longitude)" , preferredStyle: .alert)
                alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            })
            
        case 5:
            generateCrashLogs()
            
        default:
            break;
        }
    }
    
    func checkNetwok() {
        var title = ""
        var message = ""
        
        if Reachability.sharedInstance.isReachable {
            title = "Network Connection"
            message = "Your have already connected to the network."
        } else {
            title = "No Network Connection"
            message = "Please connect to some network and try again."
        }
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func generateCrashLogs() {
        let dict: NSDictionary = ["key1":"value1","key2":"value2"]
        
        // Enable writing in log file if not in DEBUG mode
        Logs.instance.enablePrintInLogFile = true
        
        // Print in console if DEBUG mode, else write in log file
        // To check the file in debug mode, commnet the preprocessor directive of if-else
        Logs.DLog(object: dict)
        
        // Send email with log file
        Logs.instance.presentEmailComposeFromViewController(vc: self, recipients: ["ankit.jayaswal@ranosys.com","kritika.middha@ranosys.com","ashish.solanki@ranosys.com"])
        
        // Clear log file content
        // Logs.clearContentsOfResponseLogFile()
    }
}

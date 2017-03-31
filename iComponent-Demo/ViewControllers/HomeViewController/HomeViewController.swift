//
//  HomeViewController.swift
//  iComponents
//
//  Created by Ranosys Technologies on 20/03/17.
//  Copyright © 2017 Ranosys. All rights reserved.
//

import UIKit
import iComponents

class HomeViewController: iComponentsViewController {

    @IBOutlet weak var componentsTableView: UITableView!
    
    let componentsArray: [String] = ["Reachability Example","iTextField Example","Zoom In/Out Example","App Tutorial Example","iLocation Example","DLog Example","Image Resize Example", "TextView Placeholder Example"]

    
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

        case 5:
            generateCrashLogs()
            
        case 6:
            let vc = (self.storyboard?.instantiateViewController(withIdentifier: "imageVC"))!
            let navigationController = UINavigationController(rootViewController: vc)
            self.present(navigationController, animated: true, completion: nil)
            
        case 7:
            let vc = (self.storyboard?.instantiateViewController(withIdentifier: "textViewVC"))!
            let navigationController = UINavigationController(rootViewController: vc)
            self.present(navigationController, animated: true, completion: nil)
            
        default:
            break;
        }
    }
    
    func checkNetwok() {
        var title = ""
        var message = ""
        
        if Reachability.sharedInstance.isReachable {
            title = "Network Connection"
            message = "You have already connected to the network."
        } else {
            title = "No Network Connection"
            message = "Please connect to some network and try again."
        }
        showToast(message: message, withDuration: 5.0)
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

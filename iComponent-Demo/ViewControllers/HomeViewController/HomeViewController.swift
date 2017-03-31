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
    
    var activityIndicator    : CustomActivityIndicatorView!
    var loaderTimer          : Timer?
    var loadedFileCount      = 0
    let noOfFiles            = 4
    
    let componentsArray: [String] = ["Reachability Example","iTextField Example","Zoom In/Out Example","App Tutorial Example","iLocation Example","DLog Example","Image Resize Example", "TextView Placeholder Example","Custom Loader With App Icon", "Custorm Loader With Progress"]

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
            UIView().funcZoomInOut(image: UIImage(named:"download")!, crossImage: UIImage(named:"cross_icon")!)
            
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
            
        case 6:
            let vc = (self.storyboard?.instantiateViewController(withIdentifier: "imageVC"))!
            let navigationController = UINavigationController(rootViewController: vc)
            self.present(navigationController, animated: true, completion: nil)
            
        case 7:
            let vc = (self.storyboard?.instantiateViewController(withIdentifier: "textViewVC"))!
            let navigationController = UINavigationController(rootViewController: vc)
            self.present(navigationController, animated: true, completion: nil)
            
        case 8:
            activityIndicator = CustomActivityIndicatorView.init (loaderActivityType: .KMLoaderWithAppIcon,loaderActivityPresentType: .KMPresentOnView, target: self, appImage: UIImage(named:"appicon")!, loadingImage: UIImage(named:"Loader")!, loadingText: "Loading...", textColor: UIColor.black, textFont: UIFont.systemFont(ofSize: 13), strokeColor: UIColor.red, strokeWidth:  5.0, percent: 0.0)
            activityIndicator.startAnimating()
            loaderTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(stopLoader), userInfo: nil, repeats: true)

        case 9:
            activityIndicator = CustomActivityIndicatorView.init(loaderActivityType: .KMLoaderWithProgress ,loaderActivityPresentType: .KMPresentOnWindow, target: self, appImage: UIImage(named:"appicon")!, loadingImage: UIImage(named:"Loader")!, loadingText:  "loading... \(loadedFileCount) / \(noOfFiles)", textColor: UIColor.black, textFont: UIFont.systemFont(ofSize: 13), strokeColor: UIColor.purple, strokeWidth:  5.0, percent: 0.0)
            
            activityIndicator.startAnimating()
            
            loaderTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.increamentSpin), userInfo: nil, repeats: true)
            
        default: break
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
    
    func increamentSpin() {
        //          increament our percentage, do so, and redraw the view
        
        let incrementPercentag = 100 / noOfFiles
        if Double(activityIndicator.percent) < 100.0 {
            loadedFileCount += 1
            activityIndicator.percent = activityIndicator.percent + Double(incrementPercentag)
            activityIndicator.loadingText = "loading... \(loadedFileCount) / \(noOfFiles)"
            activityIndicator.setNeedsDisplay()
        }
        else {
            loadedFileCount = 0
            stopLoader()
        }
    }
    
    func stopLoader() {
        loaderTimer?.invalidate()
        loaderTimer = nil
        activityIndicator.stopAnimating()

    }
    
}

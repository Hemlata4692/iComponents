//
//  IActivityLoaderViewController.swift
//  iComponents
//
//  Created by Kritika Middha on 31/03/17.
//  Copyright © 2017 Ranosys. All rights reserved.
//

import UIKit
import iComponents

class IActivityLoaderViewController: iComponentsViewController {
    
    @IBOutlet weak var customLoaderTableView: UITableView!
    
    var activityIndicator    : CustomActivityIndicatorView!
    var loaderTimer          : Timer?
    var loadedFileCount      = 0
    let noOfFiles            = 4

    let customLoaderArray: [String] = ["Custom Loader With App Icon", "Custorm Loader With Progress"]

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle(text: "Custom Activity Loader")
        
        let backBtn =  addBackBtn()
        backBtn.addTarget(self, action: #selector(actionBackButton), for: .touchUpInside)
        
        customLoaderTableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- Custom Functions
    func actionBackButton() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension IActivityLoaderViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customLoaderArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomLoaderTableCell", for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = customLoaderArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            activityIndicator = CustomActivityIndicatorView.init (loaderActivityType: .KMLoaderWithAppIcon,loaderActivityPresentType: .KMPresentOnView, target: self, appImage: UIImage(named:"appicon")!, loadingImage: UIImage(named:"Loader")!, loadingText: "Loading...", textColor: UIColor.black, textFont: UIFont.systemFont(ofSize: 13), strokeColor: UIColor.red, strokeWidth:  5.0, percent: 0.0)
            activityIndicator.startAnimating()
            loaderTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(stopLoader), userInfo: nil, repeats: true)
            
        case 1:
            activityIndicator = CustomActivityIndicatorView.init(loaderActivityType: .KMLoaderWithProgress ,loaderActivityPresentType: .KMPresentOnWindow, target: self, appImage: UIImage(named:"appicon")!, loadingImage: UIImage(named:"Loader")!, loadingText:  "loading... \(loadedFileCount) / \(noOfFiles)", textColor: UIColor.black, textFont: UIFont.systemFont(ofSize: 13), strokeColor: UIColor.purple, strokeWidth:  5.0, percent: 0.0)
            
            activityIndicator.startAnimating()
            
            loaderTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.increamentSpin), userInfo: nil, repeats: true)
            
        default: break
        }
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

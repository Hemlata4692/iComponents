//
//  ViewController.swift
//  iComponent-Demo
//
//  Created by Jogendar Singh on 06/02/17.
//  Copyright © 2017 Ranosys. All rights reserved.
//

import UIKit

enum componentViews {
    case GestureAnimationView
    case ImageCropperView
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //Constans
    //This will use for navigate on the specific component
    let GestureAnimation = "GestureAnimation"   // 0 row
    let imageCropper = "ImageCropper"           // 1 row
    var componentArray = Array<String>()
    var viewDict : Dictionary = [String:UIViewController]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        componentArray = [GestureAnimation,imageCropper]
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return componentArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = componentArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedView = componentArray[indexPath.row]
        navigateViewController(controller: selectedView)

    }
    
    func navigateViewController(controller: String)  {
        switch controller {
        case GestureAnimation:
            let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: controller) as! GestureTableViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        
        default:
            print("bye")
        }
    }
}


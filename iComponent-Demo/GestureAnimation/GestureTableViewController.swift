//
//  GestureTableViewController.swift
//  iComponents
//
//  Created by Tak Rahul on 24/02/17.
//  Copyright © 2017 Ranosys. All rights reserved.
//

import Foundation
import UIKit

class GestureTableViewController: UITableViewController {
    let gestureTable = ["singleTap","RightSwipe","LeftSwipe", "FlipAnimation"]
    
    override func viewDidLoad() {
        let backBtn =  addBackBtn()
        backBtn.addTarget(self, action: #selector(actionBackButton), for: .touchUpInside)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gestureTable.count
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = gestureTable[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Gestures"
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRowTilte = gestureTable[indexPath.row]
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "GestureView") as! GestureDetailViewController
        nextViewController.GestureType = selectedRowTilte
//        self.present(nextViewController, animated:true, completion:nil)
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    public func addBackBtn() -> UIButton {
        let leftBarBtn = UIButton()
        leftBarBtn.setImage(UIImage(named: "back"), for: .normal)
        leftBarBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftBarBtn.setTitleColor(UIColor.black, for: .normal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView:  leftBarBtn)
        return leftBarBtn
    }
    func actionBackButton() {
        self.dismiss(animated: true, completion: nil)
    }

}

//
//  GestureDetailViewController.swift
//  iComponents
//
//  Created by Tak Rahul on 02/03/17.
//  Copyright © 2017 Ranosys. All rights reserved.
//

import Foundation
import UIKit
import iComponents

class GestureDetailViewController : UIViewController {
    var GestureType = String()
    var tomImgView = UIImageView()
    var jerryImgView = UIImageView()
    var label = UILabel()
    var Btn = UIButton()
    var tomImg = #imageLiteral(resourceName: "tom")
    var jerryImg = #imageLiteral(resourceName: "jerry")

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationItem.title = "Gesture View"
        print(GestureType)
        tomImgView.frame = CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.maxY)!+20, width: 150, height: 150)
        jerryImgView.frame = CGRect(x: (self.view.frame.width/2)-75, y: tomImgView.frame.maxY + 20, width: 150, height: 150)
        Btn.frame = CGRect(x: 5, y: jerryImgView.frame.maxY + 25, width: 150, height: 50)
        label.frame = CGRect(x: Btn.frame.maxX + 20, y: jerryImgView.frame.maxY + 20, width: 150, height: 50)
        tomImgView.image = tomImg
        jerryImgView.image = jerryImg
        
        label.text = "Label"
        Btn.setTitle("Button", for: .normal)
        Btn.titleLabel?.textColor = UIColor.black
        Btn.backgroundColor = .black
        
        view.addSubview(jerryImgView)
        view.addSubview(tomImgView)
        view.addSubview(label)
        view.addSubview(Btn)
        addViewWithAnimation(animationType: GestureType)
    }
    
    func addViewWithAnimation(animationType: String){
        switch animationType {
        case "singleTap":
            label.isHidden = true
            Btn.isHidden = true
            jerryImgView.addSingleTapGestureWithResponder { (tap) in
                self.jerryImgView.image = self.jerryImgView.image == self.tomImg ? self.jerryImg : self.tomImg
            }
            tomImgView.addSingleTapGestureWithResponder { (single) in
                self.tomImgView.zoomIn()
            }
        case "FlipAnimation":
            jerryImgView.addRightSwipeGestureWithResponder { (swipe) in
                self.jerryImgView.flipWitAnimationImage(direction: UIView.Direction.right, currentImage: self.tomImg, flipWithImage: self.jerryImg)
            }
            tomImgView.addRightSwipeGestureWithResponder { (swipe) in
                self.tomImgView.flipWitAnimationImage(direction: UIView.Direction.top, currentImage: self.tomImg, flipWithImage: self.jerryImg)
            }
            label.addRightSwipeGestureWithResponder { (rightSwipe) in
                self.label.flipWitAnimation(direction: UIView.Direction.left, currentString: "Label", flipWithString: "Label flipped")
            }
            Btn.addRightSwipeGestureWithResponder { (rightSwipe) in
                self.Btn.flipWitAnimation(direction: UIView.Direction.bottom, currentString: "Button", flipWithString: "Button flipped")
            }
        case "LeftSwipe":
            label.isHidden = true
            Btn.isHidden = true
            tomImgView.isHidden = true
            jerryImgView.center = self.view.center
            jerryImgView.addLeftSwipeGestureWithResponder { (swipeLeft) in
                self.jerryImgView.image = self.jerryImgView.image == self.tomImg ? self.jerryImg : self.tomImg
            }
            
        case "RightSwipe":
            label.isHidden = true
            Btn.isHidden = true
            tomImgView.isHidden = true
            jerryImgView.center = self.view.center
            jerryImgView.addRightSwipeGestureWithResponder(responder: { (swipeRight) in
                self.jerryImgView.image = self.jerryImgView.image == self.tomImg ? self.jerryImg : self.tomImg
            })
            
        default:
            label.isHidden = true
            Btn.isHidden = true
            tomImgView.isHidden = true
            jerryImgView.center = self.view.center
            jerryImgView.addLeftSwipeGestureWithResponder { (swipeLeft) in
                self.jerryImgView.image = self.jerryImgView.image == self.tomImg ? self.jerryImg : self.tomImg
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

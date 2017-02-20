//
//  ViewController.swift
//  iComponent-Demo
//
//  Created by Jogendar Singh on 06/02/17.
//  Copyright © 2017 Ranosys. All rights reserved.
//

import UIKit
import iComponents

class ViewController: UIViewController {
    var tomImgView = UIImageView()
    var jerryImgView = UIImageView()	
    var label = UILabel()
    var Btn = UIButton()
    var tomImg = #imageLiteral(resourceName: "tom")
    var jerryImg = #imageLiteral(resourceName: "jerry")
    override func viewDidLoad() {
        super.viewDidLoad()
        tomImgView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        jerryImgView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        jerryImgView.center = self.view.center
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
        jerryImgView.addSingleTapGestureWithResponder { (tap) in
            self.jerryImgView.image = self.tomImg
        }
        jerryImgView.addRightSwipeGestureWithResponder { (swipe) in
            let transitionOptions: UIViewAnimationOptions = [.transitionFlipFromLeft, .overrideInheritedCurve]
           
            UIView.transition(with: self.jerryImgView, duration: 1.0, options: transitionOptions, animations: {
                self.jerryImgView.image = self.jerryImgView.image == self.tomImg ? self.jerryImg : self.tomImg
            })
        }
        jerryImgView.addLeftSwipeGestureWithResponder { (swipeLeft) in
            self.jerryImgView.image = self.jerryImg
        }
        
        
        tomImgView.addSingleTapGestureWithResponder { (single) in
            self.tomImgView.zoomIn()
        }
        tomImgView.addRightSwipeGestureWithResponder { (swipe) in
            self.tomImgView.flipWitAnimationImage(direction: UIView.Direction.top, currentImage: self.tomImg, flipWithImage: self.jerryImg)
        }
        label.addRightSwipeGestureWithResponder { (rightSwipe) in
            self.label.flipWitAnimation(direction: UIView.Direction.left, currentString: "Label", flipWithString: "Label Swiped")
        }
        Btn.addRightSwipeGestureWithResponder { (rightSwipe) in
            self.Btn.flipWitAnimation(direction: UIView.Direction.bottom, currentString: "Button", flipWithString: "Button Swiped")
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


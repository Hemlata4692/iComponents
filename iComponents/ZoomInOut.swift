//
//  ZoomInOut.swift
//  imReporter
//
//  Created by Kritika Middha on 17/02/17.
//  Copyright © 2017 Ranosys. All rights reserved.
//

import UIKit
/**
 ZoomInOut class is for dispaly full view of image and zoom it.
 */

class ZoomInOut{
    
    // The imageView for Zoom In/Out.
    var imageView = UIImageView()
    
    // The Scroll view for Zoom In/Out contain imageView.
    let scrollViewForImage: UIScrollView = UIScrollView()
    
    // The Boolean variable for determine whether image is zoomed by double tap.
    var doubleTapped : Bool = false
    
    // The frame of screen.
    let frame = UIScreen.main.bounds
    
    // The singlton variable of class "ZoomInOut".
    static let sharedInstance = ZoomInOut()
}

extension UIView {
    
    /**
     Setup view for Zoom In/Out and load that view on window.
     
     - parameter image: The image which will Zoom In/Out.
     */
    public func funcZoomInOut(image: UIImage) {
        // set up view
        self.frame = UIScreen.main.bounds
        self.backgroundColor = UIColor.black
        
        /// Create ScrollView for view which contain imageView

        ZoomInOut.sharedInstance.scrollViewForImage.delegate = self
        ZoomInOut.sharedInstance.scrollViewForImage.frame = CGRect(x:0, y:0, width:ZoomInOut.sharedInstance.frame.width, height:ZoomInOut.sharedInstance.frame.height-60)
        ZoomInOut.sharedInstance.scrollViewForImage.backgroundColor = UIColor.black
        ZoomInOut.sharedInstance.scrollViewForImage.alwaysBounceVertical = false
        ZoomInOut.sharedInstance.scrollViewForImage.alwaysBounceHorizontal = false
        ZoomInOut.sharedInstance.scrollViewForImage.minimumZoomScale = 1.0
        ZoomInOut.sharedInstance.scrollViewForImage.maximumZoomScale = 10.0
        
        self.addSubview(ZoomInOut.sharedInstance.scrollViewForImage)
        
        // Setup Image on scroll
        ZoomInOut.sharedInstance.imageView.frame = CGRect(x:0, y:100, width:ZoomInOut.sharedInstance.frame.width, height:ZoomInOut.sharedInstance.scrollViewForImage.frame.height-200)
        ZoomInOut.sharedInstance.imageView.image = image
        ZoomInOut.sharedInstance.imageView.isUserInteractionEnabled=true
        ZoomInOut.sharedInstance.imageView.layer.cornerRadius = 11.0
        ZoomInOut.sharedInstance.imageView.contentMode = .scaleAspectFit
        ZoomInOut.sharedInstance.imageView.clipsToBounds = false
        ZoomInOut.sharedInstance.scrollViewForImage.addSubview(ZoomInOut.sharedInstance.imageView)
        
        // Assign tap gesture on image view
        let doubleTapGesture = UITapGestureRecognizer()
        doubleTapGesture.numberOfTapsRequired = 2
        doubleTapGesture.addTarget(self, action: #selector(tappedOnImageView))
        ZoomInOut.sharedInstance.imageView.addGestureRecognizer(doubleTapGesture)
        
        // Create Close button on scroll
        let closeButton = UIButton()
        closeButton.frame = CGRect(x: self.frame.size.width/2 - 20, y: self.frame.size.height-50, width: 40, height: 40)
        closeButton.setImage(UIImage(named: "cross_icon"), for: .normal)
        closeButton.setTitleColor(UIColor.white, for: .normal)
        closeButton.titleLabel?.textAlignment = .center
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        closeButton.titleLabel?.textColor = UIColor.black
        closeButton.addTarget(self, action: #selector(removeZoomViewFromWindow), for: .touchUpInside)
        self.addSubview(closeButton)
        
        // load created Zoom In/Out view on window with animation.
        loadZoomViewOnWindow()
    }
    
    /**
      Load the Zoom In/Out view on window with bounce animation.
     */
    func loadZoomViewOnWindow() {
        if let window = UIApplication.shared.keyWindow {
            self.alpha = 0
            UIView.animate(withDuration: 0.1, animations: {
                self.alpha = 1.0
            })
            let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
            bounceAnimation.values = [0.01, 1.1, 1.0]
            bounceAnimation.keyTimes = [0.0, 0.5, 1.0]
            bounceAnimation.duration = 0.4
            self.layer.add(bounceAnimation, forKey: "bounce")
            
            window.addSubview(self)
        }
    }
    
    /**
     Return zoomed image on double tap.
     
     - parameter recognizer: tap gesture object.
     */
    func tappedOnImageView(recognizer: UITapGestureRecognizer){
        let pointInView = recognizer.location(in: ZoomInOut.sharedInstance.imageView)
        var newZoomScale : CGFloat
        
        if !ZoomInOut.sharedInstance.doubleTapped{
            ZoomInOut.sharedInstance.doubleTapped = true
            newZoomScale = ZoomInOut.sharedInstance.scrollViewForImage.zoomScale * 3.5
        } else
        {
            ZoomInOut.sharedInstance.doubleTapped = false
            newZoomScale = CGFloat(1.0)
        }
        
        newZoomScale = min(newZoomScale, ZoomInOut.sharedInstance.scrollViewForImage.maximumZoomScale)
        
        let scrollViewSize = ZoomInOut.sharedInstance.scrollViewForImage.bounds.size
        let w = scrollViewSize.width / newZoomScale
        let h = scrollViewSize.height / newZoomScale
        let x1 = pointInView.x - (w / 2.0)
        let y1 = pointInView.y - (h / 2.0)
        
        let rectToZoomTo = CGRect(x: x1, y: y1, width: w, height: h)
        
        ZoomInOut.sharedInstance.scrollViewForImage.zoom(to: rectToZoomTo, animated: true)
    }
    
    /**
     Remove the loaded  Zoom In/Out view from window.
     */
    func removeZoomViewFromWindow() {
        self.alpha = 1.0
        UIView.animate(withDuration: 0.1, animations: {
            self.alpha = 0
        })
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0, 1.1, 0.01]
        bounceAnimation.keyTimes = [0.0, 0.5, 1.0]
        bounceAnimation.duration = 0.3
        self.layer.add(bounceAnimation, forKey: "bounce")
        
        self.removeFromSuperview()
    }
}

extension UIView: UIScrollViewDelegate {
    
  
    
    //MARK:- ScrollView Delegate
    
    /**
    Return A UIView object that will be scaled as a result of the zooming gesture. Return nil if you don’t want zooming to occur.
     
     - parameter  scrollView :  The scroll-view object displaying the content view.
     */

    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return ZoomInOut.sharedInstance.imageView
    }
}

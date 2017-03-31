//
//  GesturAnimation.swift
//  iComponents
//
//  Created by Tak Rahul on 08/02/17.
//  Copyright © 2017 Ranosys. All rights reserved.
//

import Foundation
import UIKit
public extension DispatchQueue {
    
    private static var _onceTracker = [String]()
    
    /**
     Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.
     
     - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
     - parameter block: Block to execute once
     */
    public class func once(token: String, block:(Void)->Void) {
        objc_sync_enter(self); defer { objc_sync_exit(self) }
        
        if _onceTracker.contains(token) {
            return
        }
        
        _onceTracker.append(token)
        block()
    }
}
public extension UIView{
    typealias TapResponseClosure = (_ tap: UITapGestureRecognizer) -> Void
    typealias PanResponseClosure = (_ pan: UIPanGestureRecognizer) -> Void
    typealias SwipeResponseClosure = (_ swipe: UISwipeGestureRecognizer) -> Void
    typealias PinchResponseClosure = (_ pinch: UIPinchGestureRecognizer) -> Void
    typealias LongPressResponseClosure = (_ longPress: UILongPressGestureRecognizer) -> Void
    typealias RotationResponseClosure = (_ rotation: UIRotationGestureRecognizer) -> Void
    
    
    private struct ClosureStorage {
        static var TapClosureStorage: [UITapGestureRecognizer : TapResponseClosure] = [:]
        static var PanClosureStorage: [UIPanGestureRecognizer : PanResponseClosure] = [:]
        static var SwipeClosureStorage: [UISwipeGestureRecognizer : SwipeResponseClosure] = [:]
        static var PinchClosureStorage: [UIPinchGestureRecognizer : PinchResponseClosure] = [:]
        static var LongPressClosureStorage: [UILongPressGestureRecognizer: LongPressResponseClosure] = [:]
        static var RotationClosureStorage: [UIRotationGestureRecognizer: RotationResponseClosure] = [:]
    }
    private struct Swizzler {
        
        static func Swizzle() {
            DispatchQueue.once(token:"") {
                let UIViewClass: AnyClass! = NSClassFromString("UIView")
                let originalSelector = #selector(UIView.removeFromSuperview)
                let swizzleSelector = #selector(UIView.swizzled_removeFromSuperview)
                let original: Method = class_getInstanceMethod(UIViewClass, originalSelector)
                let swizzle: Method = class_getInstanceMethod(UIViewClass, swizzleSelector)
                method_exchangeImplementations(original, swizzle)
            }
        }
    }
    // direction for the flip the view
    enum Direction{
        case right
        case left
        case top
        case bottom
    }
    
    // remove gestures from superviews
    func swizzled_removeFromSuperview() {
        self.removeGestureFromStorage()
        /*
         Will call the original representation of removeFromSuperview, not endless cycle:
         http://darkdust.net/writings/objective-c/method-swizzling
         */
        self.swizzled_removeFromSuperview()
    }
    
    // remove gestures from Storage
    func removeGestureFromStorage() {
        if let gestureRec = self.gestureRecognizers {
            for recognizer: UIGestureRecognizer in gestureRec as [UIGestureRecognizer] {
                if let tap = recognizer as? UITapGestureRecognizer {
                    ClosureStorage.TapClosureStorage[tap] = nil
                }
                else if let pan = recognizer as? UIPanGestureRecognizer {
                    ClosureStorage.PanClosureStorage[pan] = nil
                }
                else if let swipe = recognizer as? UISwipeGestureRecognizer {
                    ClosureStorage.SwipeClosureStorage[swipe] = nil
                }
                else if let pinch = recognizer as? UIPinchGestureRecognizer {
                    ClosureStorage.PinchClosureStorage[pinch] = nil
                }
                else if let rotation = recognizer as? UIRotationGestureRecognizer {
                    ClosureStorage.RotationClosureStorage[rotation] = nil
                }
                else if let longPress = recognizer as? UILongPressGestureRecognizer {
                    ClosureStorage.LongPressClosureStorage[longPress] = nil
                }
            }
        }
    }
    // MARK: Taps
    // addSingle tap method view
    func addSingleTapGestureWithResponder(responder: @escaping TapResponseClosure) {
        self.addTapGestureForNumberOfTaps(withResponder: responder)
    }
    
    // addSingle tap method on view
    func addDoubleTapGestureRecognizerWithResponder(responder: @escaping TapResponseClosure) {
        self.addTapGestureForNumberOfTaps(numberOfTaps: 2, withResponder: responder)
    }
    // this method which is calls from addSingleTapGestureWithResponder and addDoubleTapGestureRecognizerWithResponder
    func addTapGestureForNumberOfTaps(numberOfTaps: Int = 1, numberOfTouches: Int = 1, withResponder responder: @escaping TapResponseClosure) {
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = numberOfTaps
        tap.numberOfTouchesRequired = numberOfTouches
        tap.addTarget(self, action: #selector(self.handleTap(sender:)))
        self.addGestureRecognizer(tap)
        
        ClosureStorage.TapClosureStorage[tap] = responder
        Swizzler.Swizzle()
    }
    
    // tap handle method whiich is implement that what functionality done when you tap on view
    func handleTap(sender: UITapGestureRecognizer) {
        if let closureForTap = ClosureStorage.TapClosureStorage[sender] {
            closureForTap(sender)
        }
    }
    // MARK: Pans
    // addSingle Touch pan gesture method on view
    func addSingleTouchPanGestureWithResponder(responder: @escaping PanResponseClosure) {
        self.addPanGestureForNumberOfTouches(numberOfTouches: 1, withResponder: responder)
    }
    // adddouble Touch pan gesture method on view
    func addDoubleTouchPanGestureWithResponder(responder: @escaping PanResponseClosure) {
        self.addPanGestureForNumberOfTouches(numberOfTouches: 2, withResponder: responder)
    }
    
    // this method which is calls from addSingleTouchPanGestureWithResponder and addDoubleTouchPanGestureWithResponder
    func addPanGestureForNumberOfTouches(numberOfTouches: Int, withResponder responder: @escaping PanResponseClosure) {
        self.isUserInteractionEnabled = true
        let pan = UIPanGestureRecognizer()
        pan.minimumNumberOfTouches = numberOfTouches
        pan.addTarget(self, action: #selector(self.handlePan(sender:)))
        self.addGestureRecognizer(pan)
        
        ClosureStorage.PanClosureStorage[pan] = responder
        Swizzler.Swizzle()
    }
    
    //  handle Pan method whiich is implement that what functionality done when you pan on view
    func handlePan(sender: UIPanGestureRecognizer) {
        if let closureForPan = ClosureStorage.PanClosureStorage[sender] {
            closureForPan(sender)
        }
    }
    // MARK: Swipes
    // add left swipe gesture on view
    func addLeftSwipeGestureWithResponder(responder: @escaping SwipeResponseClosure) {
        self.addLeftSwipeGestureForNumberOfTouches(numberOfTouches: 1, withResponder: responder)
    }
    // add left swipe method with touch on view that how many touch requires for this swipe
    func addLeftSwipeGestureForNumberOfTouches(numberOfTouches: Int, withResponder responder: @escaping SwipeResponseClosure) {
        self.addSwipeGestureForNumberOfTouches(numberOfTouches: numberOfTouches, forSwipeDirection: .left, withResponder: responder)
    }
    // add right swipe gesture on view
    func addRightSwipeGestureWithResponder(responder: @escaping SwipeResponseClosure) {
        self.addRightSwipeGestureForNumberOfTouches(numberOfTouches: 1, withResponder: responder)
    }
    
    // add right swipe method with touch on view that how many touch requires for this swipe
    func addRightSwipeGestureForNumberOfTouches(numberOfTouches: Int, withResponder responder: @escaping SwipeResponseClosure) {
        self.addSwipeGestureForNumberOfTouches(numberOfTouches: numberOfTouches, forSwipeDirection: .right, withResponder: responder)
    }
    
    // add up swipe gesture on view
    func addUpSwipeGestureWithResponder(responder: @escaping SwipeResponseClosure) {
        self.addUpSwipeGestureForNumberOfTouches(numberOfTouches: 1, withResponder: responder)
    }
    
    // add up swipe method with touch on view that how many touch requires for this swipe
    func addUpSwipeGestureForNumberOfTouches(numberOfTouches: Int, withResponder responder: @escaping SwipeResponseClosure) {
        self.addSwipeGestureForNumberOfTouches(numberOfTouches: numberOfTouches, forSwipeDirection: .up, withResponder: responder)
    }
    
    // add down swipe gesture on view
    func addDownSwipeGestureWithResponder(responder: @escaping SwipeResponseClosure) {
        self.addDownSwipeGestureForNumberOfTouches(numberOfTouches: 1, withResponder: responder)
    }
    
    // add down swipe method with touch on view that how many touch requires for this swipe
    func addDownSwipeGestureForNumberOfTouches(numberOfTouches: Int, withResponder responder: @escaping SwipeResponseClosure) {
        self.addSwipeGestureForNumberOfTouches(numberOfTouches: numberOfTouches, forSwipeDirection: .down, withResponder: responder)
    }
    
    // this is the main function whic is call from addLeftSwipeGestureForNumberOfTouches addRighrSwipeGestureForNumberOfTouches addUpSwipeGestureForNumberOfTouches addDownSwipeGestureForNumberOfTouches
    func addSwipeGestureForNumberOfTouches(numberOfTouches: Int, forSwipeDirection swipeDirection: UISwipeGestureRecognizerDirection, withResponder responder: @escaping SwipeResponseClosure) {
        self.isUserInteractionEnabled = true
        let swipe = UISwipeGestureRecognizer()
        swipe.direction = swipeDirection
        swipe.numberOfTouchesRequired = numberOfTouches
        swipe.addTarget(self, action: #selector(self.handleSwipe(sender:)))
        self.addGestureRecognizer(swipe)
        
        ClosureStorage.SwipeClosureStorage[swipe] = responder
        Swizzler.Swizzle()
    }
    // this is call from all swipe gesture
    func handleSwipe(sender: UISwipeGestureRecognizer) {
        if let closureForSwipe = ClosureStorage.SwipeClosureStorage[sender] {
            closureForSwipe(sender)
        }
    }
    
    // MARK: Pinches
    // add pinch gesture method on view
    func addPinchGestureWithResponder(responder: @escaping PinchResponseClosure) {
        self.isUserInteractionEnabled = true
        let pinch = UIPinchGestureRecognizer()
        pinch.addTarget(self, action: #selector(self.handlePinch(sender:)))
        self.addGestureRecognizer(pinch)
        
        ClosureStorage.PinchClosureStorage[pinch] = responder
        Swizzler.Swizzle()
    }
    
    // this method is handle the pinch funtionality on view
    
    func handlePinch(sender: UIPinchGestureRecognizer) {
        if let closureForPinch = ClosureStorage.PinchClosureStorage[sender] {
            closureForPinch(sender)
        }
    }
    
    // MARK: LongPress
    // add Long press gesture method on view
    func addLongPressGestureWithResponder(responder: @escaping LongPressResponseClosure) {
        self.addLongPressGestureForNumberOfTouches(numberOfTouches: 1, withResponder: responder)
    }
    
    // add Long press gesture method with number of touches on view
    func addLongPressGestureForNumberOfTouches(numberOfTouches: Int, withResponder responder: @escaping LongPressResponseClosure) {
        self.isUserInteractionEnabled = true
        let longPress = UILongPressGestureRecognizer()
        longPress.numberOfTouchesRequired = numberOfTouches
        longPress.addTarget(self, action: #selector(self.handleLongPress(sender:)))
        self.addGestureRecognizer(longPress)
        
        ClosureStorage.LongPressClosureStorage[longPress] = responder
        Swizzler.Swizzle()
    }
    
    // this method is handle the long press funtionality on view
    func handleLongPress(sender: UILongPressGestureRecognizer) {
        if let closureForLongPinch = ClosureStorage.LongPressClosureStorage[sender] {
            closureForLongPinch(sender)
        }
    }
    
    // MARK: Rotation
    // add Rotation gesture method on view
    func addRotationGestureWithResponder(responder: @escaping RotationResponseClosure) {
        self.isUserInteractionEnabled = true
        let rotation = UIRotationGestureRecognizer()
        rotation.addTarget(self, action: #selector(self.handleRotation(sender:)))
        self.addGestureRecognizer(rotation)
        
        ClosureStorage.RotationClosureStorage[rotation] = responder
        Swizzler.Swizzle()
    }
    // this method is handle the rotation funtionality on view
    func handleRotation(sender: UIRotationGestureRecognizer) {
        if let closureForRotation = ClosureStorage.RotationClosureStorage[sender] {
            closureForRotation(sender)
        }
    }
    
    // this method flip the view and replace the current image from flipWithImage
    
    func flipWitAnimationImage(direction: Direction, currentImage: UIImage ,flipWithImage: UIImage){
        let imagView : UIImageView = self as! UIImageView
        let transitionDirection = getTransitionDirection(direction: direction)
        let transitionOptions: UIViewAnimationOptions = [transitionDirection, .overrideInheritedCurve]
        
        UIView.transition(with: imagView, duration: 1.0, options: transitionOptions, animations: {
            imagView.image = imagView.image == currentImage ? flipWithImage : currentImage
        })

    }
    // this method flip the view and replace the current string from afterflip
    func flipWitAnimation(direction: Direction, currentString: String ,flipWithString: String){
        
        let transitionDirection = getTransitionDirection(direction: direction)
        let transitionOptions: UIViewAnimationOptions = [transitionDirection, .overrideInheritedCurve]
        
        UIView.transition(with: self, duration: 1.0, options: transitionOptions, animations: {
            if self.isKind(of: UILabel.self){
                let label = self as! UILabel
                label.text = label.text == currentString ? flipWithString : currentString
            }
            if self.isKind(of: UIButton.self){
                let btn = self as! UIButton
                btn.setTitle(btn.titleLabel?.text == currentString ? flipWithString : currentString, for: .normal)
            }
        })
    }
    
    // this is the file private function and we can use this function only in this file we cannot use this function outside of this file
    // this funtion return the direction in UIViewAnimationOption type
   fileprivate func getTransitionDirection(direction: Direction) -> UIViewAnimationOptions{
        switch direction {
        case .right:
            return .transitionFlipFromRight
            
        case .left:
            return .transitionFlipFromLeft
            
        case .top:
            return .transitionFlipFromTop
            
        case .bottom:
            return .transitionFlipFromBottom
            
        }

    }
    
    /**
     Simply zooming in of a view: set view scale to 0 and zoom to Identity on 'duration' time interval.
     
     - parameter duration: animation duration
     */
    func zoomIn(duration: TimeInterval = 1) {
        self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: { () -> Void in
            self.transform = CGAffineTransform.identity
        }) { (animationCompleted: Bool) -> Void in
        }
    }
    
    /**
     Simply zooming out of a view: set view scale to Identity and zoom out to 0 on 'duration' time interval.
     
     - parameter duration: animation duration
     */
    func zoomOut(duration: TimeInterval = 1) {
        self.transform = CGAffineTransform.identity
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: { () -> Void in
            self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        }) { (animationCompleted: Bool) -> Void in
        }
    }
    
    /**
     Zoom in any view with specified offset magnification.
     
     - parameter duration:     animation duration.
     - parameter easingOffset: easing offset.
     */
    func zoomInWithEasing(duration: TimeInterval = 0.2, easingOffset: CGFloat = 0.2) {
        let easeScale = 1.0 + easingOffset
        let easingDuration = TimeInterval(easingOffset) * duration / TimeInterval(easeScale)
        let scalingDuration = duration - easingDuration
        UIView.animate(withDuration: scalingDuration, delay: 0.0, options: .curveEaseIn, animations: { () -> Void in
            self.transform = CGAffineTransform(scaleX: easeScale, y: easeScale)
            }, completion: { (completed: Bool) -> Void in
                UIView.animate(withDuration: easingDuration, delay: 0.0, options: .curveEaseIn, animations: { () -> Void in
                    self.transform = CGAffineTransform.identity
                    }, completion: { (completed: Bool) -> Void in
                })
        })
    }
    
    /**
     Zoom out any view with specified offset magnification.
     
     - parameter duration:     animation duration.
     - parameter easingOffset: easing offset.
     */
    func zoomOutWithEasing(duration: TimeInterval = 0.2, easingOffset: CGFloat = 0.2) {
        let easeScale = 1.0 + easingOffset
        let easingDuration = TimeInterval(easingOffset) * duration / TimeInterval(easeScale)
        let scalingDuration = duration - easingDuration
        UIView.animate(withDuration: easingDuration, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
            self.transform = CGAffineTransform(scaleX: easeScale, y: easeScale)
            }, completion: { (completed: Bool) -> Void in
                UIView.animate(withDuration: scalingDuration, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
                    self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
                    }, completion: { (completed: Bool) -> Void in
                })
        })
    }

}


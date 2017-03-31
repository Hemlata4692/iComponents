//
//  ViewController.swift
//  CustomProgressLoader-Demo
//
//  Created by kritika Middha on 20/01/17.
//  Copyright © 2017 kritika Middha. All rights reserved.
//


import UIKit
import QuartzCore

public enum KMCustomLoaderType {
    case KMLoaderWithAppIcon
    case KMLoaderWithProgress
}

public enum KMCustomLoaderPresentType {
    case KMPresentOnWindow
    case KMPresentOnView
}

/**
 CustomActivityIndicatorView class is for dispaly progress loader either on window or view.
 */

public class CustomActivityIndicatorView: UIView {
    // MARK: - Variables
    
    // The textLabelHeight for text label height on view.
    let textLabelHeight     = 30
    
    // The topBarHeight is the NavigationBar height.
    let topBarHeight        = 64
    
    // The animationLayer is animating loader layer.
    lazy fileprivate var animationLayer : CALayer = {
        return CALayer()
    }()
    
    var isAnimating             : Bool = false
    var hidesWhenStopped        : Bool = true
    
    // The center view which contains all the object on view.
    var containerView           : UIView!
    
    // The frame of containerView.
    let centerFrame             : CGRect!
    
    // The label which shows loading text.
    var textLabel               : UILabel!
    
    // The view of ProgressLoader class which show loader with percentage.
    var progressView            : ProgressLoader!
    
    // The refernce of ViewController for show loader only on view.
    var target                  : UIViewController!
    
    // The text for TextLabel.
    public var loadingText      : String?
    
    // The text color for TextLabel.
    public var textColor        : UIColor!
    
    // The text font for TextLabel.
    public var textFont         : UIFont!
    
    // The images for loader with App Icon.
    public var appImage         : UIImage!
    public var loadingImage     : UIImage!
    
    // The percentage for progressLoader.
    public var percent          : Double!
    
    // The color of storke.
    public var strokeColor      : UIColor!
    
    // The widht of storke.
    public var strokeWidth      : CGFloat!
    
    // The type of Custom loader enumeration.
    var loaderActivityType     = KMCustomLoaderType.KMLoaderWithAppIcon
    
    // The type of Custom loader present type enumeration.
    var loaderActivityPresentType   = KMCustomLoaderPresentType.KMPresentOnWindow
    
    
    // MARK: - Init
    /**
     Setup view for customActivieyIndicator view. Pass those pararmeter which is required or all.
     
     - parameter loaderActivityType: The type of Custom loader enumeration.
     - parameter loaderActivityPresentType: The type of Custom loader present type enumeration.
     - parameter target: The refernce of ViewController for show loader only on view.
     - parameter viewBGColor: The color for .
     - parameter centerViewBGColor: customActivieyIndicator view.
     - parameter appImage: The images for loader with App Icon.
     - parameter loadingImage: he images for loader with App Icon loader.
     - parameter loadingText: The text for TextLabel.
     - parameter textColor: The color for TextLabel.
     - parameter textFont: The text font for TextLabel.
     - parameter strokeColor: The color of storke.
     - parameter strokeWidth: The widht of storke.
     - parameter percent: Initial percentage.
     
     */
    public init(loaderActivityType: KMCustomLoaderType, loaderActivityPresentType: KMCustomLoaderPresentType, target: UIViewController, viewBGColor:UIColor? = UIColor(red: 36.0/255.0, green: 36.0/255.0, blue: 36.0/255.0, alpha: 0.5), centerViewBGColor:UIColor? = UIColor.white, appImage: UIImage, loadingImage: UIImage, loadingText: String? = "Loading...", textColor: UIColor? = UIColor.black, textFont: UIFont? = UIFont.systemFont(ofSize: 16), strokeColor: UIColor? = UIColor.black, strokeWidth: CGFloat? = 5.0, percent: Double? = 0.0) {

        var frame = UIScreen.main.bounds
        
        centerFrame =  CGRect(x:(UIScreen.main.bounds.size.width/2-125/2), y:(UIScreen.main.bounds.size.height-125)/2, width:125, height:125)
        
        // Set CustomActivieyIndicator view  and center container view frames based on loaderActivityPresentType
        switch loaderActivityPresentType {
        case .KMPresentOnWindow: break
            
        case .KMPresentOnView:
            frame.origin.y = CGFloat(topBarHeight)
            frame.size.height -= CGFloat(topBarHeight)
            
            centerFrame.origin.y -= CGFloat(topBarHeight/2)
        }
        
        super.init(frame: frame)
        self.backgroundColor = viewBGColor
        
        //
        self.target         = target
        self.appImage       = appImage
        self.loadingImage   = loadingImage
        self.loadingText    = loadingText
        
        self.textColor      = textColor
        self.textFont       = textFont
        
        self.strokeColor    = strokeColor
        self.strokeWidth    = strokeWidth
        self.percent        = percent
        
        self.loaderActivityType           = loaderActivityType
        self.loaderActivityPresentType    = loaderActivityPresentType
        
        // Create center container view.
        containerView = UIView()
        containerView.frame = centerFrame
        containerView.backgroundColor = centerViewBGColor
        containerView.layer.cornerRadius = 10.0
        
        // Add TextLabel only when loading text based form viewController.
        if (loadingText != nil) {
            textLabel = UILabel ()
            textLabel.frame = CGRect(x:0, y:containerView.frame.size.height - CGFloat(textLabelHeight), width:containerView.frame.size.width, height:CGFloat(textLabelHeight))
            textLabel.textAlignment = .center
            textLabel.font = textFont
            textLabel.text = loadingText
            textLabel.textColor = textColor
            containerView.addSubview(textLabel)
        }
        self.addSubview(containerView)
        
        // Create loader based on which type of loader required.
        switch loaderActivityType {
        case .KMLoaderWithAppIcon:
            setUpLoaderWithAppIcon()
            
        case .KMLoaderWithProgress:
            setUpLoadetWithProgress()
        }
        
    }
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Start Animating loader and show on View/Window.
     */
    public func startAnimating () {
        switch loaderActivityType {
        case .KMLoaderWithAppIcon:
            if isAnimating {
                return
            }
            
            if hidesWhenStopped {
                self.isHidden = false
            }
            resume(animationLayer)
            showView()
            
        case .KMLoaderWithProgress:
            showView()
        }
    }
    
    /**
     Stop Animating loader.
     */
    public func stopAnimating () {
        switch loaderActivityType {
        case .KMLoaderWithAppIcon:
            
            if hidesWhenStopped {
                self.isHidden = true
            }
            pause(animationLayer)
            
        case .KMLoaderWithProgress:
            self.removeFromSuperview()
        }
    }
    
    // Determine that loader view display on view or window.
    func showView() {
        switch loaderActivityPresentType {
        case .KMPresentOnWindow:
            UIApplication.shared.keyWindow?.addSubview(self)
            
        case .KMPresentOnView:
            target.view.addSubview(self)
        }
    }
}

extension CustomActivityIndicatorView {
    
    /*
     Create loader with app icon.
     */
    func setUpLoaderWithAppIcon() {
        let appImageViewHeight = 50
        let remaingViewHeight = Int(containerView.frame.size.height) - textLabelHeight - appImageViewHeight
        let remaingViewWidth = Int(containerView.frame.size.width) -  appImageViewHeight
        
        // create appIcon Image view
        let appImageView = UIImageView()
        appImageView.frame = CGRect(x:remaingViewWidth/2, y:remaingViewHeight/2, width:50, height:50)
        appImageView.image = appImage
        containerView.addSubview(appImageView)
        
        // setup of animation layer
        animationLayer.frame =  CGRect(x:  containerView.frame.origin.x + CGFloat(remaingViewWidth/6), y: containerView.frame.origin.y , width: appImage.size.width, height: appImage.size.height)
        animationLayer.contents = loadingImage.cgImage
        animationLayer.masksToBounds = true
        
        // change the frame if loading text is not shown.
        if (loadingText == nil) {
            appImageView.frame.origin.y = appImageView.frame.origin.y + 15
            animationLayer.frame.origin.y = animationLayer.frame.origin.y + 15
        }
        self.layer.addSublayer(animationLayer)
        
        addRotation(forLayer: animationLayer)
        pause(animationLayer)
        self.isHidden = false
    }
    
    // MARK: - Functions for set rotation behaviour for Animating layer.
    
    /*
     Setup rotation secenario.
     - parameter forLayer: Animating layer
     */
    func addRotation(forLayer layer : CALayer) {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath:"transform.rotation.z")
        
        rotation.duration = 1.0
        rotation.isRemovedOnCompletion = false
        rotation.repeatCount = HUGE
        rotation.fillMode = kCAFillModeForwards
        rotation.fromValue = NSNumber(value: 0.0 as Float)
        rotation.toValue = NSNumber(value: 3.14 * 2.0 as Float)
        
        layer.add(rotation, forKey: "rotate")
    }
    
    /*
     Pause animating(clock wise rotation) of rotation layer.
     - parameter forLayer: Animating layer
     */
    func pause(_ layer : CALayer) {
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        
        layer.speed = 0.0
        layer.timeOffset = pausedTime
        
        isAnimating = false
    }
    
    /*
     Resume animating(clock wise rotation) of rotation layer.
     - parameter forLayer: Animating layer
     */
    func resume(_ layer : CALayer) {
        let pausedTime : CFTimeInterval = layer.timeOffset
        
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
        
        isAnimating = true
    }
}


extension CustomActivityIndicatorView {
    
    /*
     Create loader with progress loader and add it on container view.
     */
    func setUpLoadetWithProgress() {
        var progressViewFrame = CGRect(x: 0, y: 0, width: centerFrame.size.width, height: centerFrame.size.height)
        if (loadingText != nil) {
            progressViewFrame = CGRect(x: CGFloat(textLabelHeight/2), y: 0, width:centerFrame.size.width-CGFloat(textLabelHeight), height: centerFrame.size.height-CGFloat(textLabelHeight))
        }
        progressView = createPercentLoadingView(frame:progressViewFrame)
        
        containerView.addSubview(progressView)
    }
    
    override public func draw(_ rect: CGRect) {
        // call progressLoader's draw function only when progress loader type is LoaderWithProgress.
        switch loaderActivityType {
        case .KMLoaderWithProgress:
            textLabel.text = loadingText
            progressView.percent = percent
            progressView.setNeedsDisplay()
        default:
            break
        }
    }
    
    /*
     Create percentage progress loader.
     - Parameter Frame: frame for view.
     
     - ReturnType ProgressLoader: instance of ProgressLoader class.
     */
    func createPercentLoadingView(frame: CGRect) -> ProgressLoader   {
        let progressView = ProgressLoader.init(frame: frame)
        progressView.percent = 0
        progressView.strokeColor = strokeColor
        progressView.strokeWidth = strokeWidth
        progressView.textColor = textColor
        progressView.textFont = textFont
        
        return progressView
    }
}

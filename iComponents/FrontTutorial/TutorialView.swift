//
//  TutorialView.swift
//  ScrollerDemo
//
//  Created by Ranosys Technologies on 23/02/17.
//  Copyright © 2017 Ranosys. All rights reserved.
//

import UIKit

let DeviceScreenSize = UIScreen.main.bounds.size

/*
 * Delegate method for skip button
 * Where we can dismiss the view also
 */
public protocol TutorialViewDelegate {
    func actionSkipButton()
}


public class TutorialView: UIView {

    @IBOutlet weak var bottomScrollView: UIScrollView!
    @IBOutlet weak var bottomScrollChildViewWidth: NSLayoutConstraint!
    @IBOutlet weak var bottomScrollImageViewheight: NSLayoutConstraint!
    @IBOutlet weak var bottomImageView: UIImageView!
    @IBOutlet weak var topScrollView: UIScrollView!
    @IBOutlet weak var topScrollChildView: UIView!
    @IBOutlet weak var topScrollChildViewWidth: NSLayoutConstraint!
    @IBOutlet weak var pageIndicator: UIPageControl!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var skipButtonLabel: UILabel!

    /*
     * Default configuration of the view's UI
     */
    public var tutorialDelegate: TutorialViewDelegate?
    public var availableBottomScrollWidth: CGFloat?
    public var availableTopScrollWidth: CGFloat?
    public var titleFont = UIFont.boldSystemFont(ofSize: 20.0)
    public var messageFont = UIFont.systemFont(ofSize: 16.0)
    public var textColor = UIColor.black
    public var buttonThemeColor = UIColor.red
    
    public var skipButtonTitle = "Skip"
    public var titleArray: [String] = []
    public var messageArray: [String] = []
    public var topImagesArray = [UIImage]() {
        didSet {
            // Setting the upper scroll's width to show all images
            topScrollChildViewWidth.constant = DeviceScreenSize.width * CGFloat(topImagesArray.count)
            
            // Set top scroll's images
            self.setUpTopImages()
            
            // Initialize page control
            self.configurePageControl()
        }
    }
    
    /*
     * Here height of the bottom(background) image view will be calculated according to device size
     * Initially user input the size of "bottomImageView" for 4" screen
     * Size of "bottomImageVIew" for the current device's screen size will be calculated here
     *
     * NOTE:
     * BottomImageView's height will also be assigned to top image
     *
     */
    public var bottomImageRectFor4InchScreen = CGRect() {
        didSet {
            let widthForCurrentScreen = bottomImageRectFor4InchScreen.width * DeviceScreenSize.width / 320
            bottomScrollChildViewWidth.constant = widthForCurrentScreen
            
            let heightForCurrentScreen = bottomImageRectFor4InchScreen.height * DeviceScreenSize.height / 568
            bottomScrollImageViewheight.constant = heightForCurrentScreen
        }
    }
    public var setBottomViewImage = UIImage() {
        didSet {
            // Set bottom image
            bottomImageView.image = setBottomViewImage
        }
    }
    
    /*
     * Initializer function: (Returns TutorialView)
     * 
     * This function will be called from your application's view controller
     * with all the required parameter asked here
     * Tutorial view will be created with the autoresizing constraints
     *
     * NOTE:
     * Also here we will override the default values of the class if get the new values
     */
    public class func createTutorialView(vc: UIViewController,
                                         titleArray: [String]?,
                                         messageArray: [String]?,
                                         imagesArray: [UIImage]?,
                                         skipButtonText: String?,
                                         bottomImageSizeFor4InchScreen: CGSize,
                                         bottomImage: UIImage,
                                         textColor: UIColor?,
                                         themeColor: UIColor?,
                                         titleFont: UIFont?,
                                         messageFont: UIFont?) -> TutorialView {
       
        // Fetch framework bunble to load xib
        let mainBundlePath: String = Bundle.main.resourcePath!
        let frameworkBundlePath = mainBundlePath.appending("/Frameworks/iComponents.framework")
        let frameworkBundle = Bundle(path: frameworkBundlePath)
        // Load xib
        let nib = UINib.init(nibName: "TutorialView", bundle: frameworkBundle)
        let tutorialV: TutorialView = nib.instantiate(withOwner: vc, options: nil).first as! TutorialView
        
        tutorialV.bottomImageRectFor4InchScreen = CGRect(origin: CGPoint(x: 0, y: 0), size: bottomImageSizeFor4InchScreen)
        if titleFont != nil {
            tutorialV.titleFont = titleFont!
        }
        if messageFont != nil {
            tutorialV.messageFont = messageFont!
        }
        if textColor != nil {
            tutorialV.textColor = textColor!
        }
        if themeColor != nil {
            tutorialV.buttonThemeColor = themeColor!
        }
        tutorialV.setBottomViewImage = bottomImage
        tutorialV.titleArray = titleArray == nil ? [] : titleArray!
        tutorialV.messageArray = messageArray == nil ? [] : messageArray!
        tutorialV.topImagesArray = imagesArray!
        tutorialV.skipButtonTitle = skipButtonText == nil ? "Skip" : skipButtonText!
        
        return tutorialV
    }
    
    // Awake the view with theme color and UIPageControl
    override public func awakeFromNib() {
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        topScrollView.delegate = self
        bottomScrollView.delegate = self
        
        topScrollView.isPagingEnabled = true
        topScrollView.showsHorizontalScrollIndicator = false
        skipButtonLabel.textColor = buttonThemeColor
        pageIndicator.currentPageIndicatorTintColor = buttonThemeColor
        
        pageIndicator.addTarget(self, action: #selector(actionChnagePageControl), for: .valueChanged)
    }
    
    // Configuring UIPageControl
    public func configurePageControl() {
        pageIndicator.numberOfPages = topImagesArray.count
        pageIndicator.currentPage = 0
        pageIndicator.currentPageIndicatorTintColor = buttonThemeColor
        skipButtonLabel.textColor = buttonThemeColor
        self.addSubview(pageIndicator)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = frame
        availableBottomScrollWidth = nil
        availableTopScrollWidth = nil
       
        topScrollView.isPagingEnabled = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func layoutIfNeeded() {
        bottomScrollView.contentSize = CGSize(width: bottomScrollChildViewWidth.constant, height: 0)
        topScrollView.contentSize = CGSize(width: topScrollChildViewWidth.constant, height: 0)
    }
    
    
    /*
     * This method id for creting the scrollable view
     * View will have following components in same order
     *
     * - Image in upper part same height with "bottomImageView"
     * - Title
     * - Message (Height will be calculated dynamically what left after upper view and title)
     */
    public func setUpTopImages() {
        var xOrigin: CGFloat = 0.0

        var idx: Int = 0
        while idx < topImagesArray.count{
            var yOrigin: CGFloat = 0.0
            let topView = UIView.init(frame: CGRect(x: xOrigin, y: 0.0, width: DeviceScreenSize.width, height: DeviceScreenSize.height))
                topView.backgroundColor = .clear
   
            // Place image view same height with "bottomImageView"
            let imageV = UIImageView.init(frame: CGRect(x: 0.0, y: 0.0, width: DeviceScreenSize.width, height: bottomScrollImageViewheight.constant))
            imageV.image = topImagesArray[idx]
            imageV.contentMode = .scaleAspectFit
            topView.addSubview(imageV)
            yOrigin += bottomScrollImageViewheight.constant + 20
            
            // Create title view
            let titleLabel = UILabel.init(frame: CGRect(x: 0.0, y: yOrigin, width: DeviceScreenSize.width, height: 50))
            titleLabel.textAlignment = .center
            titleLabel.minimumScaleFactor = 0.5
            titleLabel.font = titleFont
            titleLabel.text = titleArray.count > idx ? titleArray[idx] : ""
            titleLabel.textColor = textColor
            topView.addSubview(titleLabel)
            yOrigin += titleLabel.frame.size.height

            // Calculate height and
            // Create message view
            let calculatedHeight = DeviceScreenSize.height - yOrigin - 40 < 90 ? DeviceScreenSize.height - yOrigin - 40 : 90
            let messageLabel = UILabel.init(frame: CGRect(x: 25.0, y: yOrigin, width: DeviceScreenSize.width - 50, height: calculatedHeight))
            messageLabel.textAlignment = .center
            messageLabel.numberOfLines = 4
            messageLabel.minimumScaleFactor = 0.5
            messageLabel.font = messageFont
            messageLabel.text = messageArray.count > idx ? messageArray[idx] : ""
            messageLabel.textColor = textColor
            topView.addSubview(messageLabel)
           // Change label's height
            let dynamicHeight = messageLabel.dynamicHeightForLabel(width: DeviceScreenSize.width - 50)
            messageLabel.frame = CGRect(x: 25.0, y: yOrigin, width: DeviceScreenSize.width - 50, height: dynamicHeight < calculatedHeight ? dynamicHeight : calculatedHeight)
            
            
            topScrollChildView.addSubview(topView)

            xOrigin += DeviceScreenSize.width
            idx += 1
        }
    }
    
    // MARK:
    // MARK: Scroll view delegates
    
    /*
     * Scrolling the images in "topImageArray", 
     * BottomImage will be scroll with respect of available width
     * Example -
     * Like there are 5 image and bottom image have width=520 on 4" screen
     * Available scroll with for bottom image = 520 - 320 = 200 (at 4")
     * bottom image will scroll 5o px for each topImage scroll
     * This will be managed as per the device screen size
     */
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == topScrollView {
            if availableBottomScrollWidth == nil || availableTopScrollWidth == nil {
                
                // Set bottom scroll width
                var difference = bottomScrollChildViewWidth.constant - DeviceScreenSize.width
                availableBottomScrollWidth = difference > 0 ? difference : 0
                
                // Set top scroll width
                difference = topScrollChildViewWidth.constant - DeviceScreenSize.width
                availableTopScrollWidth = difference > 0 ? difference : 0
                
                layoutIfNeeded()
            }
           
            let bottomScrollOffset = availableBottomScrollWidth! * topScrollView.contentOffset.x / availableTopScrollWidth!
            bottomScrollView.contentOffset = CGPoint(x: bottomScrollOffset, y: 0)
        }
    }

    
    
    /*
     * Update current page indicator of UIPageControl
     * Update the skip button text
     */
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(topScrollView.contentOffset.x / topScrollView.frame.size.width)
        pageIndicator.currentPage = Int(pageNumber)
        
        // Change button text if last screen
        let skipButtonLabelText = Int(pageNumber) + 1 == topImagesArray.count ? skipButtonTitle : "Skip"
        skipButtonLabel.text = skipButtonLabelText
    }

    
    
    // MARK:
    // MARK: Skip button click

    /*
     * Skip button clicked
     * Call the delegate method
     */
    @IBAction func actionSkipButtonClick(_ sender: UIButton) {
        tutorialDelegate?.actionSkipButton()
    }

    /*
     * Top image is scrolled
     * Change the current page indicator of UIPageControl
     */
    @objc func actionChnagePageControl() {
        let x = CGFloat(pageIndicator.currentPage) * topScrollView.frame.size.width
        topScrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
    }

}


// MARK: Dynamic height for label

extension UILabel {
    
    /*
     * Calculate height of the label dynamically
     * according to content
     */
    func dynamicHeightForLabel(width: CGFloat) -> CGFloat {
        let label: UILabel = UILabel(frame: CGRect.init(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = self.font
        label.text = self.text
        label.sizeToFit()
        
        return label.frame.height + 20
    }
}

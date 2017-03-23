//
//  AppTutorialViewController.swift
//  iComponents
//
//  Created by Ranosys Technologies on 20/03/17.
//  Copyright © 2017 Ranosys. All rights reserved.
//

import UIKit
import iComponents

let kScreenSize = UIScreen.main.bounds.size
let kSkyBlueThemeColor = UIColor(colorLiteralRed: 0.0/255.0, green: 192.0/255.0, blue: 233.0/255.0, alpha: 1.0)
let kLetsReport = "Let's Report"

// View Constants and images
let kBackgroundImage = UIImage(named: "background_image")
let kScreen1Image = UIImage(named: "screen_1")
let kScreen2Image = UIImage(named: "screen_2")
let kScreen3Image = UIImage(named: "screen_3")
let kScreen4Image = UIImage(named: "screen_4")
let kScreen5Image = UIImage(named: "screen_5")

let kScreen1Title = "View Nearby Reports"
let kScreen2Title = "View Detailed Report"
let kScreen3Title = "Submit a Report"
let kScreen4Title = "Form C-team"
let kScreen5Title = "Other User Profile"

let kScreen1Message = "View reports submitted by users nearby"
let kScreen2Message = "View report details including location and severity"
let kScreen3Message = "Become a reporter! Tell us what you see [espicially municipal issues]"
let kScreen4Message = "Form your contributor team by choosing good contributors to vote for! If you choose the right people, you will earn many more credits!"
let kScreen5Message = "View another user's profile [Trust Capital, Trust Index, Competency] and, if you like, add him/her to your Discovery Zone"


class AppTutorialViewController: iComponentsViewController,TutorialViewDelegate {

    // MARK:
    // MARK: View Methods
    func actionBackButton() {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
            
        let titleArr: [String] = [kScreen1Title,
                                  kScreen2Title,
                                  kScreen3Title,
                                  kScreen4Title,
                                  kScreen5Title]
        
        let messageArr: [String] = [kScreen1Message,
                                    kScreen2Message,
                                    kScreen3Message,
                                    kScreen4Message,
                                    kScreen5Message]
        
        let imgArr: [UIImage] = [kScreen1Image!,
                                 kScreen2Image!,
                                 kScreen3Image!,
                                 kScreen4Image!,
                                 kScreen5Image!]
        
        let bottomImage: UIImage = kBackgroundImage!
        
        weak var weakSelf = self
        let tutorialScreen =
            TutorialView.createTutorialView(vc: weakSelf!,
                                            titleArray: titleArr,
                                            messageArray: messageArr,
                                            imagesArray: imgArr,
                                            skipButtonText: kLetsReport,
                                            bottomImageSizeFor4InchScreen: CGSize(width: 854, height: 366),
                                            bottomImage: bottomImage,
                                            textColor: UIColor.black,
                                            themeColor: kSkyBlueThemeColor,
                                            titleFont: UIFont.systemFont(ofSize: 22.0),
                                            messageFont: UIFont.systemFont(ofSize: 17.0))
        tutorialScreen.frame = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: kScreenSize)
        tutorialScreen.tutorialDelegate = self
        self.view.addSubview(tutorialScreen)
    }
    
    func actionSkipButton() {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//
//  ImageCropperViewController.swift
//  iComponents
//
//  Created by Tak Rahul on 03/03/17.
//  Copyright © 2017 Ranosys. All rights reserved.
//

import Foundation
import UIKit
import iComponents


class ImageCropperViewController: iImagePickerController,UITextFieldDelegate {
    
    
    var imagePicker = UIImagePickerController()
    var isOval = true
    @IBOutlet weak var ProfileImageView: UIImageView!
    var backImageView = UIImageView()
    var cropWidth = String()
    var cropHeight = String()
    @IBOutlet weak var transparentView: UIView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var isOvalCropSwitch: UISwitch!
    @IBOutlet weak var txtCropWidth: UITextField!
    @IBOutlet weak var textCropHeight: UITextField!
    @IBAction func OkPressed(_ sender: AnyObject) {
        getImageCropData()
        transparentView.zoomOutWithEasing()
        let when = DispatchTime.now() + 1 // change 1 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Your code with delay
            self.transparentView.isHidden = true
            self.transparentView.zoomIn()
        }
//        ActionSheetForChoosePhoto()
        self.loadImagePicker(cameraAccess: true, galleryAccess: true, ovalCrop: isOval, cropSize: CGSize(width: CGFloat((cropWidth as NSString).doubleValue) , height: CGFloat((cropHeight as NSString).doubleValue)), selectMessage: "Choose Photo")
    }
    
    @IBAction func cancelPressed(_ sender: AnyObject) {
        
        transparentView.zoomOutWithEasing()
        cropHeight = "0"
        cropWidth   = "0"
        isOval = true
        isOvalCropSwitch.setOn(true, animated: true)
        let when = DispatchTime.now() + 1 // change 1 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Your code with delay
            self.transparentView.isHidden = true
            self.transparentView.zoomIn()
        }
    }
    @IBAction func isOvalCropPressed(_ sender: AnyObject) {
        if isOvalCropSwitch.isOn{
            isOval = true
        } else {
            isOval = false
        }
    }
    
    
    @IBAction func editProfilePhoto(_ sender: AnyObject) {
        //        ActionSheetForChoosePhoto()
        textCropHeight.text = ""
        txtCropWidth.text = ""
        isOvalCropSwitch.setOn(true, animated: true)
        isOval = true
        transparentView.isHidden = false
        alertView.zoomIn(duration: 0.5)
    }
    
    func getImageCropData(){
        if !(textCropHeight.text?.isEmpty)! && !(txtCropWidth.text?.isEmpty)! {
            cropWidth = txtCropWidth.text!
            cropHeight = textCropHeight.text!
        } else {
            cropWidth = "0"
            cropHeight = "0"
        }
        transparentView.isHidden = true
        //        ActionSheetForChoosePhoto()
    }
    
     override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setView()
        
        
    }
    func setView(){
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        alertView.layer.cornerRadius = 5
        imagePicker.delegate = self
        ProfileImageView.isUserInteractionEnabled = true
        self.view.addSubview(backImageView)
        self.view.sendSubview(toBack: backImageView)
        transparentView.isHidden = true
        txtCropWidth.delegate = self
        textCropHeight.delegate = self
        let backBtn =  addBackBtn()
        backBtn.addTarget(self, action: #selector(actionBackButton), for: .touchUpInside)
    }

     override func iImagePickerController(_ imagePicker: iImagePickerController!, croppedImage: UIImage!) {
        ProfileImageView.image = croppedImage
        ProfileImageView.contentMode = .scaleAspectFit
        backImageView.image = croppedImage
        addBlurEffect(blurView: backImageView)
        backImageView.frame.size = CGSize(width: ProfileImageView.frame.size.width + 20, height: ProfileImageView.frame.size.height + 20)
        backImageView.center = ProfileImageView.center
//        dismiss(animated: false, completion: nil)

    }
    
     override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func addBlurEffect(blurView: UIView)
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = blurView.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        blurView.addSubview(blurEffectView)
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

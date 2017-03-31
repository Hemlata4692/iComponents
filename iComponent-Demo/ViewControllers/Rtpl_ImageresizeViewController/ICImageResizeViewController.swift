//
//  ICImageResizeViewController.swift
//  iComponents
//
//  Created by Roshan Singh Bisht on 30/03/17.
//  Copyright © 2017 Ranosys. All rights reserved.
//

import Foundation
import iComponents
import UIKit

class ICImageResizeViewController: iComponentsViewController {
    @IBOutlet weak var imageViewBeforeCompression:          UIImageView!
    @IBOutlet weak var labelToshowSizeBeforeCompreesion:    UILabel!
    @IBOutlet weak var labelToshowSizeAfterCompreesion:     UILabel!
    @IBOutlet weak var imageViewAfterCompression:           UIImageView!
    var imagePicker =                                       UIImagePickerController()
    
    @IBAction func btnClicked() {
        self.createAndCallPicker()
    }
    
    func actionBackButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        let backBtn =  addBackBtn()
        backBtn.addTarget(self, action: #selector(actionBackButton), for: .touchUpInside)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ICImageResizeViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageViewBeforeCompression.image = image
        } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            // original image size
            let imageData: Data = UIImagePNGRepresentation(image)!
            UIGraphicsEndImageContext()
            
            // image size after using the iComponent
            let imagedataAfterConversion : Data = image.resizeImageToUploadOnServer()
            
            let formatter = ByteCountFormatter()
            formatter.allowedUnits = ByteCountFormatter.Units.useKB
            formatter.countStyle = ByteCountFormatter.CountStyle.file
            
            //printing the image before image conversion
            let imageSize = formatter.string(fromByteCount: Int64(imageData.count))
            
            //printing the image after using the image iComponent
            let imageSizeAfterCompression = formatter.string(fromByteCount: Int64(imagedataAfterConversion.count))
            
            labelToshowSizeBeforeCompreesion.text = String(" befor converion image isze is \(imageSize)")
            labelToshowSizeAfterCompreesion.text = String(" After converion image isze is \(imageSizeAfterCompression)")
            
            //printing the the images
            imageViewBeforeCompression.image = image
            
            //printing the image after resizing the image with fix scale given
            imageViewAfterCompression.image = image.reSizeImage()
            
            //printing the image after resizing the image with given scale given
            //            let size = CGSize(width: 20, height: 30)
            //            imageAfterCompression.image = image.imageResize(sizeChange: size);
        } else {
            imageViewBeforeCompression.image = nil
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)    {
        dismiss(animated: true, completion: nil)
    }
    
    func createAndCallPicker() -> (Void) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum){
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
}

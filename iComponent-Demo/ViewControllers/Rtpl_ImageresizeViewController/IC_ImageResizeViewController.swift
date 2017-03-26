//
//  IC_ImageResizeViewController.swift
//  iComponents
//
//  Created by Roshan Singh Bisht on 25/03/17.
//  Copyright © 2017 Ranosys. All rights reserved.
//
import iComponents
import UIKit

class IC_ImageResizeViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet weak var imageViewDemo: UIImageView!
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var after: UILabel!
    @IBOutlet weak var before: UILabel!
    @IBOutlet weak var imageAfterCompression: UIImageView!
    @IBAction func btnClicked() {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum){
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    imagePicker.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageViewDemo.image = image
        } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {

            // original image size
            let imageData: Data = UIImageJPEGRepresentation(image, 1.0)!
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

            before.text = String(" befor converion image isze is \(imageSize)")
            after.text = String(" After converion image isze is \(imageSizeAfterCompression)")
            
            //printing the the images
            imageViewDemo.image = image
            
            //printing the image after resizing the image with fix scale given
            imageAfterCompression.image = image.reSizeImage()
            
            //printing the image after resizing the image with given scale given
            let size = CGSize(width: 20, height: 30)
            imageAfterCompression.image = image.imageResize(sizeChange: size);
        } else {
            imageViewDemo.image = nil
        }
    }

    
}

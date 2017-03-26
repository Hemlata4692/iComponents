//
//  Rtpl_ImageResize.swift
//  iComponents
//
//  Created by Roshan Singh Bisht on 25/03/17.
//  Copyright © 2017 Ranosys. All rights reserved.
//

import UIKit

extension UIImage {
    
   public func imageResize(sizeChange:CGSize)-> UIImage {
        let hasAlpha = true
        let scale: CGFloat = 0.0 // Use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        self.draw(in: CGRect(origin: CGPoint.zero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage!
    }
    
   public func resizeImageToUploadOnServer() -> Data {
        print("\(self.size)")
        let resizedImage = self.reSizeImage()
        
        var scale: CGFloat = 0.8
        var (size, imageData) = resizedImage.logImageSizeInKB(scale: scale)
        
        while size > 600 {
            scale = scale - 0.1
            if scale > 0 {
                (size, imageData) = resizedImage.logImageSizeInKB(scale: scale)
            } else {
                break
            }
        }
        
        return imageData
    }
    
   public func logImageSizeInKB(scale: CGFloat) -> (Int, Data) {
        let data = UIImageJPEGRepresentation(self, scale)!
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = ByteCountFormatter.Units.useKB
        formatter.countStyle = ByteCountFormatter.CountStyle.file
        let imageSize = formatter.string(fromByteCount: Int64(data.count))
        print("ImageSize(KB): \(imageSize)")
        
        return (Int(Int64(data.count) / 1024), data)
    }
    
   public func reSizeImage() -> UIImage {
        var actualHeight = Float(self.size.height)
        var actualWidth = Float(self.size.width)
        let maxHeight: Float = 500.0
        let maxWidth: Float = 500.0
        var imgRatio: Float = actualWidth / actualHeight
        let maxRatio: Float = maxWidth / maxHeight
        let compressionQuality: CGFloat = 1.0
        
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imgRatio < maxRatio {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            } else if imgRatio > maxRatio {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            } else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        
        let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
        UIGraphicsBeginImageContext(rect.size)
        self.draw(in: rect)
        
        let img = UIGraphicsGetImageFromCurrentImageContext()!
        let imageData: Data = UIImageJPEGRepresentation(img, compressionQuality)!
        UIGraphicsEndImageContext()
        
        return UIImage(data:imageData)!
        
    }
}


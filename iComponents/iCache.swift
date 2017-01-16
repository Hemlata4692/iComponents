//
//  iCache.swift
//  iComponents
//
//  Created by Jogendar Singh on 11/01/17.
//  Copyright © 2017 Ranosys. All rights reserved.
//

import Foundation
import UIKit

class ImageLoader {
    
    var cache = NSCache<AnyObject, AnyObject>()
    
    class var sharedLoader : ImageLoader {
        struct Static {
            static let instance : ImageLoader = ImageLoader()
        }
        return Static.instance
    }
    
    class func imageFromCacheForUrl(urlString: String, completionHandler:@escaping (_ image: UIImage?, _ url: String) -> ()) {
        
        DispatchQueue.global(qos: .background).async {
            ()in
            let data: NSData? = sharedLoader.cache.object(forKey: urlString as AnyObject) as? NSData
            
            if let goodData = data {
                let image = UIImage(data: goodData as Data)
                DispatchQueue.main.async {
                    completionHandler(image, urlString)
                }
                return
            }
            let url = URL(string: urlString)
            
            
            let downloadTask: URLSessionDataTask = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                if (error != nil) {
                    completionHandler(nil, urlString)
                    return
                }
                
                if data != nil {
                    let image = UIImage(data: data!)
                    sharedLoader.cache.setObject(data as AnyObject, forKey: urlString as AnyObject)
                    DispatchQueue.main.async {
                        completionHandler(image, urlString)
                    }
                    
                    return
                }
                
            })
            downloadTask.resume()
            
        }
        
    }
    
    class func imageForUrl(urlString: String,withPath filePath:String, completionHandler:@escaping (_ image: UIImage?, _ url: String) -> ()) {
        
        DispatchQueue.global(qos: .background).async {
            ()in
            let data: NSData? = sharedLoader.cache.object(forKey: urlString as AnyObject) as? NSData
            
            if let goodData = data {
                let image = UIImage(data: goodData as Data)
                DispatchQueue.main.async {
                    completionHandler(image, urlString)
                }
                return
            } else {
                let getImagePath = filePath.appending(urlString)
                let checkValidation = FileManager.default
                if (checkValidation.fileExists(atPath: getImagePath)) {
                    DispatchQueue.main.async {
                        let image    = UIImage(contentsOfFile: getImagePath)
                        completionHandler(image, urlString)
                    }
                    return
                }
            }
            
            let url = URL(string: urlString)
            let downloadTask: URLSessionDataTask = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                if (error != nil) {
                    completionHandler(nil, urlString)
                    return
                }
                
                if data != nil {
                    let image = UIImage(data: data!)
                    sharedLoader.cache.setObject(data as AnyObject, forKey: urlString as AnyObject)
                    DispatchQueue.main.async {
                        var filePathTemp:Array = filePath.appending(urlString).components(separatedBy: "/")
                        filePathTemp.removeLast()
                        let filePathTempStr = filePathTemp.joined(separator: "/")
                        try!FileManager.default.createDirectory(atPath: filePathTempStr, withIntermediateDirectories: true, attributes: nil)
                        let path = URL.init(fileURLWithPath:filePath).appendingPathComponent(urlString)
                        try! data?.write(to: path, options: .atomicWrite)
                        completionHandler(image, urlString)
                    }
                    return
                }
            })
            downloadTask.resume()
            
        }
        
    }
    
}
extension FileManager {
    class public func documentsDir() -> String {
        var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [String]
        return paths[0]
    }
    
    class func cachesDir() -> String {
        var paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true) as [String]
        return paths[0]
    }
}
extension UIImageView {
    
    public func SetImageUsingCacheWithURLString(urlStr: String) {
        ImageLoader.imageFromCacheForUrl(urlString: urlStr) { (image, string) in
            DispatchQueue.main.async {
                self.image = image
            }
        }
        
    }
    
    public func SetImageUsingCacheWithURLString(urlStr: String , withPlaceholderImage placeholderImage:UIImage) {
        self.image = placeholderImage
        ImageLoader.imageFromCacheForUrl(urlString: urlStr) { (image, string) in
            DispatchQueue.main.async {
                if let isImage = image {
                    self.image = isImage
                }
            }
        }
        
    }
    
    public func SetImageUsingCacheDirectoryWithURLString(urlStr: String) {
        var cacheDire = FileManager.cachesDir()
        cacheDire.append("/")
        ImageLoader.imageForUrl(urlString: urlStr, withPath: cacheDire) { (image, string) in
            DispatchQueue.main.async {
                self.image = image
            }
        }
        
    }
    
    public func SetImageUsingCacheDirectoryWithURLString(urlStr: String, withPlaceholderImage placeholderImage:UIImage) {
        self.image = placeholderImage
        var cacheDire = FileManager.cachesDir()
        cacheDire.append("/")
        ImageLoader.imageForUrl(urlString: urlStr, withPath: cacheDire) { (image, string) in
            DispatchQueue.main.async {
                if let isImage = image {
                    self.image = isImage
                }
            }
        }
    }
    
    public func SetImageUsingDirectoryWithURLString(urlStr: String) {
        var documentsDire = FileManager.documentsDir()
        documentsDire.append("/")
        ImageLoader.imageForUrl(urlString: urlStr, withPath: documentsDire) { (image, string) in
            DispatchQueue.main.async {
                self.image = image
            }
        }
        
    }
    
    public func SetImageUsingDirectoryWithURLString(urlStr: String, withPlaceholderImage placeholderImage:UIImage) {
        self.image = placeholderImage
        var documentsDire = FileManager.documentsDir()
        documentsDire.append("/")
        ImageLoader.imageForUrl(urlString: urlStr, withPath: documentsDire) { (image, string) in
            DispatchQueue.main.async {
                if let isImage = image {
                    self.image = isImage
                }
            }
        }
        
    }
    
}

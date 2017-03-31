//
//  ICToastView.swift
//  iComponents
//
//  Created by Mradul Mathur on 28/03/17.
//  Copyright © 2017 Ranosys. All rights reserved.
//

import Foundation

public extension UIViewController {
    
    public func showToast(message : String, withDuration:CGFloat) {
        let font = UIFont.systemFont(ofSize: 16.0)
        let labelWidth = self.view.frame.size.width - 40
        let labelTextHeight = self.getLabelHeight(text: message, font: font, width: labelWidth)
        let labelTextWidth = self.getLabelWidth(text: message, font: font, width: labelWidth)
        let toastLabel = UILabel(frame: CGRect(x: (self.view.frame.size.width - labelTextWidth)/2 , y: self.view.frame.size.height - labelTextHeight - 40, width: labelTextWidth, height: labelTextHeight + 10))
        toastLabel.backgroundColor = UIColor.black
        toastLabel.textColor = UIColor.white
        toastLabel.numberOfLines = 0
        toastLabel.textAlignment = .center
        toastLabel.font = font
        toastLabel.alpha = 1.0
        toastLabel.text = message
        toastLabel.layer.cornerRadius = 15
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: TimeInterval(withDuration), delay: 0.2, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
    //Code snippet to get message actual height
    public func getLabelHeight(text:String, font:UIFont, width:CGFloat) -> CGFloat {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width , height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height > 100 ? 100 : label.frame.height
    }
    //Code snippet to get message actual width
    public func getLabelWidth(text:String, font:UIFont, width:CGFloat) -> CGFloat {
        let dummyLabel = UILabel.init()
        dummyLabel.text = text
        return dummyLabel.intrinsicContentSize.width > width ? width : dummyLabel.intrinsicContentSize.width + 10
    }
}


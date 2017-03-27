//
//  PullToRefresh.swift
//  iComponents
//
//  Created by Kritika Middha on 23/03/17.
//  Copyright © 2017 Ranosys. All rights reserved.
//

import UIKit

extension UIRefreshControl {
    
    public func refreshConroller(view : UIView, AttributeString : String, backgroundColor: UIColor, tintColor: UIColor, textColor: UIColor) -> UIRefreshControl {
    
        self.backgroundColor = backgroundColor
        self.attributedTitle = NSAttributedString(string: AttributeString, attributes:[NSForegroundColorAttributeName:textColor])
        self.tintColor = tintColor
        view.addSubview(self)
        
        return self
    }
}

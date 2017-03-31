//
//  ProgressLoader.swift
//  CircleProgressBar
//
//  Created by Kritika Middha on 29/03/17.
//  Copyright © 2017 Kritika Middha. All rights reserved.
//

import UIKit

class ProgressLoader: UIView {
    var percent: Double     = 0.0
    var startAngle: CGFloat = 0.0
    var endAngle: CGFloat   = 0.0
    
    var constant            : CGFloat!
    var textColor           : UIColor!
    var textFont            : UIFont!
    var label               : UILabel!
    
    var strokeColor         : UIColor!
    var strokeWidth         : CGFloat!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Initialization code
        backgroundColor = UIColor.clear
        
        // Determine our start and stop angles for the arc (in radians)
        startAngle = .pi * 1.5
        endAngle = startAngle + (.pi * 2)
        constant = frame.size.width / 5

        label = UILabel(frame: CGRect(x: CGFloat(constant / 2), y: CGFloat(constant / 2), width: CGFloat(frame.size.width - constant), height: CGFloat(frame.size.height - constant)))
        label.font = textFont
        label.textColor = textColor
        label.textAlignment = .center
        addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        // Change label text with updated percent.
        label.text = "\(percent) %"
        
        // Create our arc, with the correct angles
        let bezierPath = UIBezierPath()
        bezierPath.addArc(withCenter: CGPoint(x: CGFloat(rect.size.width / 2), y: CGFloat(rect.size.height / 2)), radius: constant * 2, startAngle: startAngle, endAngle: CGFloat(endAngle - startAngle) * CGFloat(percent / 100.0) + CGFloat(startAngle), clockwise: true)
        
        bezierPath.lineWidth = strokeWidth
        strokeColor.setStroke()
        bezierPath.stroke()
    }
}

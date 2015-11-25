//
//  RFProgressButton.swift
//  RFProgressButton
//
//  Created by Guilherme Moura on 11/24/15.
//  Copyright © 2015 Reefactor, Inc. All rights reserved.
//

import UIKit

public class RFProgressButton: UIButton {
    
    public init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public func addInView(superview: UIView) {
//        let button = UIButton(type: .Custom)
//        button.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        backgroundColor = UIColor.greenColor()
        translatesAutoresizingMaskIntoConstraints = false
        
        superview.addSubview(self)
        
        let views = ["addButton": self, "bar": superview]
        let constraintsV = NSLayoutConstraint.constraintsWithVisualFormat("V:[addButton]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        let centerX = NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem: superview, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
        let width = NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 60.0)
        let height = NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 60.0)
        superview.addConstraints(constraintsV)
        superview.addConstraint(centerX)
        addConstraint(width)
        addConstraint(height)
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

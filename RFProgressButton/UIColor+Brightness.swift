//
//  UIColor+Brightness.swift
//  RFProgressButton
//
//  Created by Guilherme Moura on 11/27/15.
//  Copyright © 2015 Reefactor, Inc. All rights reserved.
//

import UIKit

extension UIColor {
    func colorWithBrightnessFactor(factor: CGFloat) -> UIColor {
        var hue : CGFloat = 0
        var saturation : CGFloat = 0
        var brightness : CGFloat = 0
        var alpha : CGFloat = 0
        
        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: hue, saturation: saturation, brightness: brightness * factor, alpha: alpha)
        } else {
            return self;
        }
    }
}

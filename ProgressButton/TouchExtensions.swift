//
//  TouchExtensions.swift
//  ProgressButton
//
//  Created by Guilherme Moura on 11/28/15.
//  Copyright © 2015 Reefactor, Inc. All rights reserved.
//

import UIKit

extension UIToolbar {
    public override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        let views = subviews
        var button: UIView? = nil
        for view in views {
            if view.isKindOfClass(ProgressButton) {
                button = view
            }
        }
        guard let progress = button else {
            return super.pointInside(point, withEvent: event)
        }
        return super.pointInside(point, withEvent: event) || CGRectContainsPoint(progress.frame, point)
    }
}

extension UITabBar {
    public override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        let views = self.subviews
        var button: UIView? = nil
        for view in views {
            if view.isKindOfClass(ProgressButton) {
                button = view
            }
        }
        guard let progress = button else {
            return super.pointInside(point, withEvent: event)
        }
        return super.pointInside(point, withEvent: event) || CGRectContainsPoint(progress.frame, point)
    }
}
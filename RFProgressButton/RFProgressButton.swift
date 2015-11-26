//
//  RFProgressButton.swift
//  RFProgressButton
//
//  Created by Guilherme Moura on 11/24/15.
//  Copyright © 2015 Reefactor, Inc. All rights reserved.
//

import UIKit

@IBDesignable
public class RFProgressButton: UIButton {
    
    @IBInspectable public var buttonColor = UIColor.whiteColor()
    @IBInspectable public var symbolColor = UIColor.blackColor()
    private var circleLayer: CAShapeLayer! = nil
    private var animationDuration = 1.0
    private var currentProgress = 0.3
    
    public init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        self.addTarget(self, action: "open:", forControlEvents: .TouchUpInside)
        createProgressArcLayer()
        
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public func addInView(superview: UIView) {
//        let button = UIButton(type: .Custom)
//        button.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        translatesAutoresizingMaskIntoConstraints = false
        
        superview.addSubview(self)
        
        let views = ["addButton": self, "bar": superview]
        let constraintsV = NSLayoutConstraint.constraintsWithVisualFormat("V:[addButton]-(-10)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        let centerX = NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem: superview, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
        let width = NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 60.0)
        let height = NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 60.0)
        superview.addConstraints(constraintsV)
        superview.addConstraint(centerX)
        addConstraint(width)
        addConstraint(height)
    }
    
    public override func drawRect(rect: CGRect) {
        // Circle background
        let path = UIBezierPath(ovalInRect: rect)
        buttonColor.setFill()
        path.fill()
        
        drawPlusSymbol()
        drawProgressTrackArc()
    }
    
    func open(sender: UIButton) {
        print("button")
        setProgress(0.8, animated: true)
    }
    
    // MARK: - Private methods
    private func drawPlusSymbol() {
        //set up the width and height variables
        //for the horizontal stroke
        let plusHeight: CGFloat = 2.0
        let plusWidth: CGFloat = min(bounds.width, bounds.height) * 0.35
        
        //create the path
        let plusPath = UIBezierPath()
        
        //set the path's line width to the height of the stroke
        plusPath.lineWidth = plusHeight
        
        //move the initial point of the path
        //to the start of the horizontal stroke
        plusPath.moveToPoint(CGPoint(x:bounds.width/2 - plusWidth/2, y:bounds.height/2))
        
        //add a point to the path at the end of the stroke
        plusPath.addLineToPoint(CGPoint(x:bounds.width/2 + plusWidth/2, y:bounds.height/2))
        
        //Vertical Line
        //move to the start of the vertical stroke
        plusPath.moveToPoint(CGPoint(x:bounds.width/2 + 0.5, y:bounds.height/2 - plusWidth/2 + 0.5))
        
        //add the end point to the vertical stroke
        plusPath.addLineToPoint(CGPoint(x:bounds.width/2 + 0.5, y:bounds.height/2 + plusWidth/2 + 0.5))
        
        //set the stroke color
        symbolColor.setStroke()
        
        //draw the stroke
        plusPath.stroke()
    }
    
    private func drawProgressTrackArc() {
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        let radius: CGFloat = max(bounds.width, bounds.height) - 2.0
        let arcWidth: CGFloat = 2
        let startAngle: Double = 12314814815.0 * M_PI / 16666666667.0
        let endAngle: Double = 4351851852.0 * M_PI / 16666666667.0
    
        let path = UIBezierPath(arcCenter: center,
            radius: radius/2 - arcWidth/2,
            startAngle: CGFloat(startAngle),
            endAngle: CGFloat(endAngle),
            clockwise: true)
        
        path.lineWidth = arcWidth
        UIColor.lightGrayColor().setStroke()
        path.stroke()
    }
    
    private func createProgressArcLayer() {
        let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
        let radius: CGFloat = max(bounds.width, bounds.height) - 2.0
        let arcWidth: CGFloat = 2
        let startAngle: Double = 12314814815.0 * M_PI / 16666666667.0
        let endAngle: Double = 4351851852.0 * M_PI / 16666666667.0
        
        let circlePath = UIBezierPath(arcCenter: center,
            radius: radius/2 - arcWidth/2,
            startAngle: CGFloat(startAngle),
            endAngle: CGFloat(endAngle),
            clockwise: true)
        
        circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.CGPath
        circleLayer.fillColor = UIColor.clearColor().CGColor
        circleLayer.strokeColor = UIColor.greenColor().CGColor
        circleLayer.lineWidth = 2.0;
        
        circleLayer.strokeEnd = CGFloat(currentProgress)
        
        layer.addSublayer(circleLayer)
    }
    
    private func setProgress(progress: Double, animated: Bool) {
        // We want to animate the strokeEnd property of the circleLayer
        let animation = CABasicAnimation(keyPath: "strokeEnd")

        animation.duration = animated ? animationDuration : 0.0
        animation.fromValue = currentProgress
        animation.toValue = progress
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        // Set the circleLayer's strokeEnd property to 1.0 now so that it's the
        // right value when the animation ends.
        circleLayer.strokeEnd = CGFloat(progress)
        
        // Do the actual animation
        circleLayer.addAnimation(animation, forKey: "animateProgress")
        
        // Save the new progress state
        currentProgress = progress
    }
    
}

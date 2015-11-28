//
//  RFProgressButton.swift
//  RFProgressButton
//
//  Created by Guilherme Moura on 11/24/15.
//  Copyright © 2015 Reefactor, Inc. All rights reserved.
//

import UIKit

public class RFProgressButton: UIButton {
    // Private Interface
    private var currentBackgroundColor = UIColor.whiteColor()
    private var savedBackgroundColor = UIColor.whiteColor()
    private var circleLayer: CAShapeLayer! = nil
    private var currentProgress = 0.0
    private var viewCenter: CGPoint {
        return CGPoint(x:bounds.width/2, y: bounds.height/2)
    }
    private var radius: CGFloat {
        return max(bounds.width, bounds.height) - 2.0
    }
    private let arcWidth: CGFloat = 2
    private var startAngle: Double {
        return initialAngle + arcOffset
    }
    private var endAngle: Double {
        return initialAngle - arcOffset
    }
    
    // Public Interface
    public override var highlighted: Bool {
        get {
            return super.highlighted
        }
        set {
            if newValue {
                currentBackgroundColor = buttonColor.colorWithBrightnessFactor(0.8)
            } else {
                currentBackgroundColor = buttonColor
            }
            super.highlighted = newValue
            self.setNeedsDisplay()
        }
    }
    public var buttonColor = UIColor.whiteColor() {
        didSet {
            currentBackgroundColor = buttonColor
        }
    }
    
    /// Progress stroke color for the first level before the `advisoryThreshold`
    public var normalProgressColor = UIColor.greenColor()
    public var advisoryProgressColor = UIColor.orangeColor()
    public var warningProgressColor = UIColor.redColor()
    public var advisoryProgressThreshold = 0.6
    public var warningProgressThreshold = 0.85
    public var symbolColor = UIColor.blackColor()
    public var animationDuration = 1.0
    
    /// Starting point, in radian angles, where the progress arc will begin. Default: π/2
    public var initialAngle: Double = M_PI_2 {
        didSet {
            self.circleLayer.removeFromSuperlayer()
            createProgressArcLayer()
        }
    }
    
    /// Arc offset, in radian angles, from `initialAngle` where the progress arc will start drawing. Default: π/6
    public var arcOffset: Double = M_PI / 6.0 {
        didSet {
            self.circleLayer.removeFromSuperlayer()
            createProgressArcLayer()
        }
    }
    
    // MARK: - View life-cycle
    public init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        self.addTarget(self, action: "open:", forControlEvents: .TouchUpInside)
        createProgressArcLayer()
        createShadow()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTarget(self, action: "open:", forControlEvents: .TouchUpInside)
        createProgressArcLayer()
        createShadow()
    }
    
    public convenience init(size: CGSize) {
        self.init(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func drawRect(rect: CGRect) {
        drawCircleBackgroud(rect)
        drawPlusSymbol()
        drawProgressTrackArc()
    }
    
    func open(sender: UIButton) {
        print("button")
        setProgress(currentProgress + 0.2, animated: true)
    }
    
    // MARK: - Public interface
    public func addInView(superview: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        superview.addSubview(self)
        
        // Create constraints
        let views = ["addButton": self, "bar": superview]
        let constraintsV = NSLayoutConstraint.constraintsWithVisualFormat("V:[addButton]-(-6)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        let centerX = NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem: superview, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
        let width = NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 60.0)
        let height = NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 60.0)
        superview.addConstraints(constraintsV)
        superview.addConstraint(centerX)
        addConstraint(width)
        addConstraint(height)
    }
    
    public func setProgress(progress: Double, animated: Bool) {
        let clampedProgress = min(1.0, max(0.0, progress))
        animateStrokePath(clampedProgress, animated: animated)
        animateStrokeColor(clampedProgress, animated: animated)
        
        // Save the new progress state
        currentProgress = clampedProgress
    }
    
    // MARK: - Private methods
    private func drawCircleBackgroud(rect: CGRect) {
        let path = UIBezierPath(ovalInRect: rect)
        currentBackgroundColor.setFill()
        path.fill()
    }
    
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
        let path = UIBezierPath(arcCenter: viewCenter,
            radius: radius/2 - arcWidth/2,
            startAngle: CGFloat(startAngle + 0.0001),
            endAngle: CGFloat(endAngle - 0.0001),
            clockwise: true)
        
        path.lineWidth = arcWidth
        UIColor.lightGrayColor().setStroke()
        path.stroke()
    }
    
    private func createProgressArcLayer() {
        let circlePath = UIBezierPath(arcCenter: viewCenter,
            radius: radius/2 - arcWidth/2,
            startAngle: CGFloat(startAngle + 0.0001),
            endAngle: CGFloat(endAngle - 0.0001),
            clockwise: true)
        
        circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.CGPath
        circleLayer.fillColor = UIColor.clearColor().CGColor
        circleLayer.strokeColor = calculateProgressColor(0.0).CGColor
        circleLayer.lineWidth = 2.0;
        
        circleLayer.strokeEnd = CGFloat(currentProgress)
        
        layer.addSublayer(circleLayer)
    }
    
    private func createShadow() {
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOffset = CGSizeZero
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 2
    }
    
    private func calculateProgressColor(progress: Double) -> UIColor {
        switch progress {
        case 0.0..<advisoryProgressThreshold:
            return normalProgressColor
        case advisoryProgressThreshold..<warningProgressThreshold:
            return advisoryProgressColor
        case warningProgressThreshold...1.0:
            return warningProgressColor
        default:
            return normalProgressColor
        }
    }
    
    private func animateStrokePath(progress: Double, animated: Bool) {
        // We want to animate the strokeEnd property of the circleLayer
        let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        strokeAnimation.duration = animated ? animationDuration : 0.0
        strokeAnimation.fromValue = currentProgress
        strokeAnimation.toValue = progress
        strokeAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        // Set the circleLayer's strokeEnd property to 1.0 now so that it's the
        // right value when the animation ends.
        circleLayer.strokeEnd = CGFloat(progress)
        
        // Do the actual animation
        circleLayer.addAnimation(strokeAnimation, forKey: "animateProgress")
    }
    
    private func animateStrokeColor(progress: Double, animated: Bool) {
        // We want to animate the strokeEnd property of the circleLayer
        let colorAnimation = CABasicAnimation(keyPath: "strokeColor")
        
        colorAnimation.duration = animated ? animationDuration : 0.0
        colorAnimation.fromValue = calculateProgressColor(currentProgress).CGColor
        colorAnimation.toValue = calculateProgressColor(progress).CGColor
        colorAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        // Set the circleLayer's strokeEnd property to 1.0 now so that it's the
        // right value when the animation ends.
        circleLayer.strokeColor = calculateProgressColor(progress).CGColor
        
        // Do the actual animation
        circleLayer.addAnimation(colorAnimation, forKey: "animateColor")
    }
}

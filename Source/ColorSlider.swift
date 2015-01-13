//
//  ColorSlider.swift
//
//  Created by Sachin Patel on 1/11/15.
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015-Present Sachin Patel (http://gizmosachin.com/)
//    
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//    
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//    
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.


import UIKit
import Foundation
import CoreGraphics

public class ColorSlider: UIControl {
    // Currently selected color
    public var color: UIColor {
        return UIColor(h: hue, s: 1.0, l: lightness, alpha: 1.0)
    }
    
    // Settable properties
    public var padding: CGFloat = 15.0
    public var cornerRadius: CGFloat? {
        didSet {
            setNeedsDisplay()
        }
    }
    public var borderWidth: CGFloat? {
        didSet {
            setNeedsDisplay()
        }
    }
    public var borderColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // Internal
    private var hue: CGFloat = 0.0
    private var lightness: CGFloat = 0.5
    
    // MARK: Initializers
    public override init() {
        super.init()
        backgroundColor = UIColor.clearColor()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
    }
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clearColor()
    }
    
    // MARK: UIControl methods
    override public func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) -> Bool {
        super.beginTrackingWithTouch(touch, withEvent: event)
        
        // Set color based on initial touch
        updateForTouch(touch, inside: true)
        lightness = 0.5
        
        sendActionsForControlEvents(UIControlEvents.TouchDown)
        return true
    }
    
    override public func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) -> Bool {
        super.continueTrackingWithTouch(touch, withEvent: event)
        
        // Allow padding before switching to modifying lightness
        var loc = touch.locationInView(self)
        var insideX = loc.x > -padding && loc.x < frame.width + padding
        var insideY = loc.y > -padding && loc.y < frame.height + padding
        updateForTouch(touch, inside: insideX && insideY)
        
        sendActionsForControlEvents(UIControlEvents.ValueChanged)
        return true
    }
    
    override public func endTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) {
        super.endTrackingWithTouch(touch, withEvent: event)
        
        updateForTouch(touch, inside: touchInside)
        
        if touchInside {
            sendActionsForControlEvents(UIControlEvents.TouchUpInside)
        } else {
            sendActionsForControlEvents(UIControlEvents.TouchUpOutside)
        }
    }
    
    private func updateForTouch (touch: UITouch, inside: Bool) {
        if inside {
            // Modify the hue at constant lightness
            var locationInView = touch.locationInView(self)
            hue = 1 - (locationInView.y / self.frame.height)
            lightness = 0.5
        } else {
            // Modify the lightness for the current hue
            var locationInSuperview = touch.locationInView(self.superview)
            lightness = 1 - (locationInSuperview.y / self.superview!.frame.height)
        }
    }
    
    // MARK: Appearance
    public override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        // Draw border
        if cornerRadius != nil {
            // Use the defined corner radius
            layer.cornerRadius = cornerRadius!
        } else {
            // Default to pill shape
            var shortestSide = (frame.width > frame.height) ? frame.height : frame.width
            layer.cornerRadius = shortestSide / 2.0
        }
        
        if borderWidth != nil {
            // Use the defined border width
            layer.borderWidth = borderWidth!
        } else {
            // Default to 1
            layer.borderWidth = 1.0
        }
        
        if borderColor != nil {
            // Use the defined border color
            layer.borderColor = borderColor!.CGColor
        } else {
            // Default to black
            layer.borderColor = UIColor.blackColor().CGColor
        }
        
        // Draw background
        var backgroundGradientLayer = CAGradientLayer()
        backgroundGradientLayer.colors = [UIColor(h: 1, s: 1.0, l: 0.5, alpha: 1.0).CGColor,
                                          UIColor(h: 0.9, s: 1.0, l: 0.5, alpha: 1.0).CGColor,
                                          UIColor(h: 0.8, s: 1.0, l: 0.5, alpha: 1.0).CGColor,
                                          UIColor(h: 0.7, s: 1.0, l: 0.5, alpha: 1.0).CGColor,
                                          UIColor(h: 0.6, s: 1.0, l: 0.5, alpha: 1.0).CGColor,
                                          UIColor(h: 0.5, s: 1.0, l: 0.5, alpha: 1.0).CGColor,
                                          UIColor(h: 0.4, s: 1.0, l: 0.5, alpha: 1.0).CGColor,
                                          UIColor(h: 0.3, s: 1.0, l: 0.5, alpha: 1.0).CGColor,
                                          UIColor(h: 0.2, s: 1.0, l: 0.5, alpha: 1.0).CGColor,
                                          UIColor(h: 0.1, s: 1.0, l: 0.5, alpha: 1.0).CGColor,
                                          UIColor(h: 0.0, s: 1.0, l: 0.5, alpha: 1.0).CGColor]
        backgroundGradientLayer.locations = [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]
        backgroundGradientLayer.frame = self.bounds
        layer.insertSublayer(backgroundGradientLayer, atIndex: 0)
        
        self.clipsToBounds = true
    }
}

public extension UIColor {
    // Adapted from https://github.com/thisandagain/color
    public convenience init(h: CGFloat, s: CGFloat, l: CGFloat, alpha: CGFloat) {
        var temp1: CGFloat = 0.0
        var temp2: CGFloat = 0.0
        var temp: [CGFloat] = [0.0, 0.0, 0.0]
        var i = 0
        
        var outR: CGFloat = 0.0
        var outG: CGFloat = 0.0
        var outB: CGFloat = 0.0
        
        // Check for saturation. If there isn't any just return the luminance value for each, which results in gray.
        if (s == 0.0) {
            outR = l
            outG = l
            outB = l
        } else {
            if l < 0.5 {
                temp2 = l * (1.0 + s)
            } else {
                temp2 = l + s - l * s
                temp1 = 2.0 * l - temp2
            }
            
            // Compute intermediate values based on hue
            temp[0] = h + 1.0 / 3.0
            temp[1] = h
            temp[2] = h - 1.0 / 3.0
            
            for (i = 0; i < 3; ++i) {
                // Adjust the range
                if (temp[i] < 0.0) {
                    temp[i] += 1.0
                }
                if (temp[i] > 1.0) {
                    temp[i] -= 1.0
                }
                
                
                if 6.0 * temp[i] < 1.0 {
                    temp[i] = temp1 + (temp2 - temp1) * 6.0 * temp[i]
                } else {
                    if 2.0 * temp[i] < 1.0 {
                        temp[i] = temp2
                    } else {
                        if (3.0 * temp[i] < 2.0) {
                            temp[i] = temp1 + (temp2 - temp1) * ((2.0 / 3.0) - temp[i]) * 6.0
                        } else {
                            temp[i] = temp1
                        }
                    }
                }
            }
            
            // Assign temporary values to R, G, B
            outR = temp[0]
            outG = temp[1]
            outB = temp[2]
        }
        self.init(red: outR, green: outG, blue: outB, alpha: alpha)
    }
}
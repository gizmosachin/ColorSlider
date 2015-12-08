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

public enum ColorSliderOrientation {
    case Vertical
    case Horizontal
}

@IBDesignable public class ColorSlider: UIControl {
    public var color: UIColor {
        return UIColor(h: hue, s: 1, l: lightness, alpha: 1)
    }
    
    // MARK: - Settable properties
    public var edgeInsets: UIEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 20) {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable public var cornerRadius: CGFloat = -1.0 {
        didSet {
            drawLayer.cornerRadius = cornerRadius
            drawLayer.masksToBounds = true
        }
    }
    @IBInspectable public var borderWidth: CGFloat = 1.0 {
        didSet { drawLayer.borderWidth = borderWidth }
    }
    @IBInspectable public var borderColor: UIColor = UIColor.blackColor() {
        didSet { drawLayer.borderColor = borderColor.CGColor }
    }
    
    public var orientation: ColorSliderOrientation = .Vertical {
        didSet {
            switch orientation {
				case .Vertical:
					drawLayer.startPoint = CGPointMake(0.5, 1)
					drawLayer.endPoint = CGPointMake(0.5, 0)
				case .Horizontal:
					drawLayer.startPoint = CGPointMake(0, 0.5)
					drawLayer.endPoint = CGPointMake(1, 0.5)
			}
		}
	}
	
    // MARK: Internal properties
    private var drawLayer: CAGradientLayer = CAGradientLayer()
    private var hue: CGFloat = 0.0
    private var lightness: CGFloat = 0.5
	
	// MARK: Preview view
	@IBInspectable public var previewEnabled: Bool = false
    private var previewView: UIView = UIView()
	private let previewDimension: CGFloat = 32
	private let previewAnimationDuration: NSTimeInterval = 0.15
	
    // MARK: - Initializers
	convenience init() {
        self.init()
       	commonInit()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
		commonInit()
    }
	
	func commonInit() {
		backgroundColor = UIColor.clearColor()
		clipsToBounds = false
		
		previewView.clipsToBounds = true
		previewView.layer.cornerRadius = previewDimension / 2
	}
	
    // MARK: - UIControl methods
    public override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        super.beginTrackingWithTouch(touch, withEvent: event)
        
        updateForTouch(touch, modifyHue: true)
        showPreview(touch)
        
        sendActionsForControlEvents(.TouchDown)
        return true
    }
    
    public override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        super.continueTrackingWithTouch(touch, withEvent: event)
        
        updateForTouch(touch, modifyHue: touchInside)
        updatePreview(touch)
        
        sendActionsForControlEvents(.ValueChanged)
        return true
    }
    
    public override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        super.endTrackingWithTouch(touch, withEvent: event)
		
		guard let endTouch = touch else { return }
        updateForTouch(endTouch, modifyHue: touchInside)
        removePreview()
		
		sendActionsForControlEvents(touchInside ? .TouchUpInside : .TouchUpOutside)
    }
    
    public override func cancelTrackingWithEvent(event: UIEvent?) {
        sendActionsForControlEvents(.TouchCancel)
    }
    
    private func updateForTouch(touch: UITouch, modifyHue: Bool) {
        if modifyHue {
            // Modify hue at constant lightness
            let locationInView = touch.locationInView(self)
			let top = orientation == .Vertical ? locationInView.y : locationInView.x
			let bottom = orientation == .Vertical ? frame.height : frame.width
			hue = 1 - min(1, max(0, (top / bottom)))
            lightness = 0.5
        } else {
            // Modify lightness for the current hue
			guard let _superview = superview else { return }
			let locationInSuperview = touch.locationInView(_superview)
			let top = orientation == .Vertical ? locationInSuperview.y : locationInSuperview.x
			let bottom = orientation == .Vertical ? _superview.frame.height : _superview.frame.width
			lightness = 1 - (top / bottom)
        }
    }
	
    // MARK: - Appearance
    public override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        // Bounds - Edge Insets
        let innerFrame = UIEdgeInsetsInsetRect(bounds, edgeInsets)
        
        // Draw border
        if cornerRadius >= 0 {
            // Use the defined corner radius
            drawLayer.cornerRadius = cornerRadius
        } else {
            // Default to pill shape
			let shortestSide = (innerFrame.width > innerFrame.height) ? innerFrame.height : innerFrame.width
            drawLayer.cornerRadius = shortestSide / 2.0
        }
        
        // Draw background
		let locations: [CGFloat] = [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]
        drawLayer.locations = locations
		drawLayer.colors = locations.reverse().map({ (hue) -> CGColor in
			return UIColor(h: hue, s: 1, l: 0.5, alpha: 1).CGColor
		})
        drawLayer.frame = innerFrame
        drawLayer.borderColor = borderColor.CGColor
        drawLayer.borderWidth = borderWidth
        if drawLayer.superlayer == nil {
            layer.insertSublayer(drawLayer, atIndex: 0)
        }
    }
    
    // MARK: - Preview
    func showPreview(touch: UITouch) {
		if !previewEnabled { return }
		
        // Initialize preview in proper position, save frame
        updatePreview(touch)
        let endFrame = previewView.frame
        
        // Get frame for animation, set as current frame to navigate _from_
        previewView.frame = minimizedRectForRect(endFrame)
        
        addSubview(previewView)
        UIView.animateWithDuration(previewAnimationDuration, delay: 0, options: [.BeginFromCurrentState, .CurveEaseInOut], animations: { () -> Void in
            self.previewView.frame = endFrame
		}, completion: nil)
    }
    
    func updatePreview(touch: UITouch) {
		if !previewEnabled { return }
		let frame = positionForPreview(touch)
		previewView.frame = frame
		previewView.backgroundColor = color
    }
	
    func removePreview() {
		if !previewEnabled { return }
		let endFrame = minimizedRectForRect(previewView.frame)
		UIView.animateWithDuration(previewAnimationDuration, delay: 0, options: [.BeginFromCurrentState, .CurveEaseInOut], animations: { () -> Void in
			self.previewView.frame = endFrame
		}, completion: { (completed: Bool) -> Void in
			self.previewView.removeFromSuperview()
		})
    }
	
    func positionForPreview(touch: UITouch) -> CGRect {
        let location = touch.locationInView(self)
		
		var x = -CGFloat(44)
		var y = location.y
		
		// Restrict preview to slider bounds
        if orientation == .Vertical {
			y = max(0, location.y - (previewDimension / 2))
			y = min(bounds.height - previewDimension, y)
        } else {
			x = max(0, location.x - (previewDimension / 2))
			x = min(bounds.width - previewDimension, x)
        }
		
		return CGRect(x: x, y: y, width: previewDimension, height: previewDimension)
    }
    
    func minimizedRectForRect(rect: CGRect) -> CGRect {
        let minimizedDimension: CGFloat = 5.0
		let position = orientation == .Vertical ? rect.origin.y : rect.origin.x
		let minimizedPosition = position + ((previewDimension - minimizedDimension) / 2)
		let x = orientation == .Vertical ? bounds.width / 2 : minimizedPosition
		let y = orientation == .Vertical ? minimizedPosition : bounds.height / 2
		return CGRect(x: x, y: y, width: minimizedDimension, height: minimizedDimension)
    }
}

// MARK: -

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
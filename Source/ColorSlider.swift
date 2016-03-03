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

@IBDesignable public class ColorSlider: UIControl {
	
	public var color: UIColor {
		return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
	}
	
	// MARK: Customization
	public enum Orientation {
		case Vertical
		case Horizontal
	}
	public var orientation: Orientation = .Vertical {
		didSet {
			switch orientation {
			case .Vertical:
				drawLayer.startPoint = CGPoint(x: 0.5, y: 1)
				drawLayer.endPoint = CGPoint(x: 0.5, y: 0)
			case .Horizontal:
				drawLayer.startPoint = CGPoint(x: 0, y: 0.5)
				drawLayer.endPoint = CGPoint(x: 1, y: 0.5)
			}
		}
	}
	@IBInspectable public var previewEnabled: Bool = false
	@IBInspectable public var borderWidth: CGFloat = 1.0 {
		didSet {
			drawLayer.borderWidth = borderWidth
		}
	}
	@IBInspectable public var borderColor: UIColor = UIColor.blackColor() {
		didSet {
			drawLayer.borderColor = borderColor.CGColor
		}
	}
	
    // MARK: Internal
    private var drawLayer: CAGradientLayer = CAGradientLayer()
    private var hue: CGFloat = 0
	private var saturation: CGFloat = 1
    private var brightness: CGFloat = 1
	
	// MARK: Preview view
	private var previewView: UIView = UIView()
	private let previewDimension: CGFloat = 30
	private let previewOffset: CGFloat = 44
	private let previewAnimationDuration: NSTimeInterval = 0.10
	
    // MARK: - Initializers
	public init() {
		super.init(frame: CGRectZero)
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
	
	public func commonInit() {
		backgroundColor = UIColor.clearColor()
		
		drawLayer.masksToBounds = true
		drawLayer.cornerRadius = 3.0
		drawLayer.borderColor = borderColor.CGColor
		drawLayer.borderWidth = borderWidth
		drawLayer.startPoint = CGPoint(x: 0.5, y: 1)
		drawLayer.endPoint = CGPoint(x: 0.5, y: 0)
		
		// Draw gradient
		let hues: [CGFloat] = [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]
		drawLayer.locations = hues
		drawLayer.colors = hues.map({ (hue) -> CGColor in
			return UIColor(hue: hue, saturation: 1, brightness: 1, alpha: 1).CGColor
		})
		
		previewView.clipsToBounds = true
		previewView.layer.cornerRadius = previewDimension / 2
		previewView.layer.borderColor = UIColor.blackColor().colorWithAlphaComponent(0.3).CGColor
		previewView.layer.borderWidth = 1.0
	}
	
    // MARK: - UIControl overrides
    public override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        super.beginTrackingWithTouch(touch, withEvent: event)
		
		// Reset saturation and brightness
		saturation = 1.0
		brightness = 1.0
		
        updateForTouch(touch, touchInside: true)
		
        showPreview(touch)
        
        sendActionsForControlEvents(.TouchDown)
        return true
    }
    
    public override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        super.continueTrackingWithTouch(touch, withEvent: event)
        
        updateForTouch(touch, touchInside: touchInside)
		
        updatePreview(touch)
        
        sendActionsForControlEvents(.ValueChanged)
        return true
    }
    
    public override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        super.endTrackingWithTouch(touch, withEvent: event)
		
		guard let endTouch = touch else { return }
        updateForTouch(endTouch, touchInside: touchInside)
		
        removePreview()
		
		sendActionsForControlEvents(touchInside ? .TouchUpInside : .TouchUpOutside)
    }
    
    public override func cancelTrackingWithEvent(event: UIEvent?) {
        sendActionsForControlEvents(.TouchCancel)
    }
	
	// MARK: -
    private func updateForTouch(touch: UITouch, touchInside: Bool) {
        if touchInside {
            // Modify hue at constant brightness
            let locationInView = touch.locationInView(self)
			
			// Calculate based on orientation
			if orientation == .Vertical {
				hue = 1 - max(0, min(1, (locationInView.y / frame.height)))
			} else {
				hue = 1 - max(0, min(1, (locationInView.x / frame.width)))
			}
            brightness = 1
			
        } else {
            // Modify saturation and brightness for the current hue
			guard let _superview = superview else { return }
			let locationInSuperview = touch.locationInView(_superview)
			let horizontalPercent = max(0, min(1, (locationInSuperview.x / _superview.frame.width)))
			let verticalPercent = max(0, min(1, (locationInSuperview.y / _superview.frame.height)))
			
			// Calculate based on orientation
			if orientation == .Vertical {
				saturation = horizontalPercent
				brightness = 1 - verticalPercent
			} else {
				saturation = verticalPercent
				brightness = 1 - horizontalPercent
			}
        }
    }
	
    // MARK: - Appearance
    public override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
		// Draw pill shape
		let shortestSide = (bounds.width > bounds.height) ? bounds.height : bounds.width
		drawLayer.cornerRadius = shortestSide / 2.0
		
        // Draw background
		drawLayer.frame = bounds
        if drawLayer.superlayer == nil {
            layer.insertSublayer(drawLayer, atIndex: 0)
        }
    }
    
    // MARK: - Preview
    private func showPreview(touch: UITouch) {
		if !previewEnabled { return }
		
        // Initialize preview in proper position, save frame
        updatePreview(touch)
		previewView.transform = minimizedTransformForRect(previewView.frame)
        
        addSubview(previewView)
        UIView.animateWithDuration(previewAnimationDuration, delay: 0, options: [.BeginFromCurrentState, .CurveEaseInOut], animations: { () -> Void in
            self.previewView.transform = CGAffineTransformIdentity
		}, completion: nil)
    }
    
    private func updatePreview(touch: UITouch) {
		if !previewEnabled { return }
		
		// Calculate the position of the preview
		let location = touch.locationInView(self)
		var x = orientation == .Vertical ? -previewOffset : location.x
		var y = orientation == .Vertical ? location.y : -previewOffset
		
		// Restrict preview frame to slider bounds
		if orientation == .Vertical {
			y = max(0, location.y - (previewDimension / 2))
			y = min(bounds.height - previewDimension, y)
		} else {
			x = max(0, location.x - (previewDimension / 2))
			x = min(bounds.width - previewDimension, x)
		}
		
		// Update the preview view
		let previewFrame = CGRect(x: x, y: y, width: previewDimension, height: previewDimension)
		previewView.frame = previewFrame
		previewView.backgroundColor = color
    }
	
    private func removePreview() {
		if !previewEnabled || previewView.superview == nil { return }
		
		UIView.animateWithDuration(previewAnimationDuration, delay: 0, options: [.BeginFromCurrentState, .CurveEaseInOut], animations: { () -> Void in
			self.previewView.transform = self.minimizedTransformForRect(self.previewView.frame)
		}, completion: { (completed: Bool) -> Void in
			self.previewView.removeFromSuperview()
			self.previewView.transform = CGAffineTransformIdentity
		})
    }
    
    private func minimizedTransformForRect(rect: CGRect) -> CGAffineTransform {
        let minimizedDimension: CGFloat = 5.0
		
		let scale = minimizedDimension / previewDimension
		let scaleTransform = CGAffineTransformMakeScale(scale, scale)
		
		let tx = orientation == .Vertical ? previewOffset : 0
		let ty = orientation == .Vertical ? 0 : previewOffset
		let translationTransform = CGAffineTransformMakeTranslation(tx, ty)
		
		return CGAffineTransformConcat(scaleTransform, translationTransform)
    }
}

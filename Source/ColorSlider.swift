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

/// The main ColorSlider class.
@IBDesignable public class ColorSlider: UIControl {
	/// The current color of the `ColorSlider`.
	public var color: UIColor {
		return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
	}
	
	// MARK: Customization
	/// The display orientation of the `ColorSlider`.
	public enum Orientation {
		/// Displays `ColorSlider` vertically.
		case Vertical
		
		/// Displays `ColorSlider` horizontally.
		case Horizontal
	}
	
	/// The orientation of the `ColorSlider`. Defaults to `.Vertical`.
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
	
	/// A boolean value that determines whether or not a color preview is shown while dragging.
	@IBInspectable public var previewEnabled: Bool = false
	
	/// The width of the ColorSlider's border.
	@IBInspectable public var borderWidth: CGFloat = 1.0 {
		didSet {
			drawLayer.borderWidth = borderWidth
		}
	}
	
	/// The color of the ColorSlider's border.
	@IBInspectable public var borderColor: UIColor = UIColor.blackColor() {
		didSet {
			drawLayer.borderColor = borderColor.CGColor
		}
	}
	
    // MARK: Internal
	/// Internal `CAGradientLayer` used for drawing the `ColorSlider`.
    private var drawLayer: CAGradientLayer = CAGradientLayer()
	
	/// The hue of the current color.
    private var hue: CGFloat = 0
	
	/// The saturation of the current color.
	private var saturation: CGFloat = 1
	
	/// The brightness of the current color.
    private var brightness: CGFloat = 1
	
	// MARK: Preview view
	/// The color preview view. Only shown if `previewEnabled` is set to `true`.
	private var previewView: UIView = UIView()
	
	/// The edge length of the preview view.
	private let previewDimension: CGFloat = 30
	
	/// The amount that the `previewView` is drawn away from the `ColorSlider` bar.
	private let previewOffset: CGFloat = 44
	
	/// The duration of the preview show or hide animation.
	private let previewAnimationDuration: NSTimeInterval = 0.10
	
    // MARK: - Initializers
	/// Creates a `ColorSlider` with a frame of `CGRect.zero`.
	public init() {
		super.init(frame: CGRect.zero)
		commonInit()
    }
	
	/// Creates a `ColorSlider` with a frame of `frame`.
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
	}
	
	/// Creates a `ColorSlider` from Interface Builder.
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
		commonInit()
    }
	
	/// Sets up internal views.
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
	
    // MARK: - UIControl
	/// Begins tracking a touch when the user drags on the `ColorSlider`.
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
	
	/// Continues tracking a touch as the user drags on the `ColorSlider`.
    public override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        super.continueTrackingWithTouch(touch, withEvent: event)
        
        updateForTouch(touch, touchInside: touchInside)
		
        updatePreview(touch)
        
        sendActionsForControlEvents(.ValueChanged)
        return true
    }
	
	/// Ends tracking a touch when the user finishes dragging on the `ColorSlider`.
    public override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        super.endTrackingWithTouch(touch, withEvent: event)
		
		guard let endTouch = touch else { return }
        updateForTouch(endTouch, touchInside: touchInside)
		
        removePreview()
		
		sendActionsForControlEvents(touchInside ? .TouchUpInside : .TouchUpOutside)
    }
	
	/// Cancels tracking a touch when the user cancels dragging on the `ColorSlider`.
    public override func cancelTrackingWithEvent(event: UIEvent?) {
        sendActionsForControlEvents(.TouchCancel)
    }
	
	// MARK: -
	///	Updates the `ColorSlider` color.
	///
	///	- parameter touch: The touch that triggered the update.
	///	- parameter touchInside: A boolean value that is `true` if `touch` was inside the frame of the `ColorSlider`.
    private func updateForTouch(touch: UITouch, touchInside: Bool) {
        if touchInside {
            // Modify hue at constant brightness
            let locationInView = touch.locationInView(self)
			
			// Calculate based on orientation
			if orientation == .Vertical {
				hue = 1 - max(0, min(1, (locationInView.y / frame.height)))
			} else {
				hue = max(0, min(1, (locationInView.x / frame.width)))
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
	
	/// Draws necessary parts of the `ColorSlider`.
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
	///	Shows the color preview.
	///
	///	- parameter touch: The touch that triggered the update.
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
	
	///	Updates the color preview.
	///
	///	- parameter touch: The touch that triggered the update.
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
		
		// Update the preview
		let previewFrame = CGRect(x: x, y: y, width: previewDimension, height: previewDimension)
		previewView.frame = previewFrame
		previewView.backgroundColor = color
    }
	
	/// Removes the color preview
    private func removePreview() {
		if !previewEnabled || previewView.superview == nil { return }
		
		UIView.animateWithDuration(previewAnimationDuration, delay: 0, options: [.BeginFromCurrentState, .CurveEaseInOut], animations: { () -> Void in
			self.previewView.transform = self.minimizedTransformForRect(self.previewView.frame)
		}, completion: { (completed: Bool) -> Void in
			self.previewView.removeFromSuperview()
			self.previewView.transform = CGAffineTransformIdentity
		})
    }
	
	///	Calculates the transform from `rect` to the minimized preview view.
	///
	///	- parameter rect: The actual frame of the preview view.
	///	- returns: The transform from `rect` to generate the minimized preview view.
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

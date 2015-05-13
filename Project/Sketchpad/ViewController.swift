//
//  ViewController.swift
//  Sketchpad
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

class ViewController: UIViewController, ACEDrawingViewDelegate {
    @IBOutlet var drawingView: ACEDrawingView!
    @IBOutlet var colorSlider: ColorSlider!
    @IBOutlet var selectedColorView: UIView!
    @IBOutlet var undoButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        drawingView.delegate = self
        drawingView.lineWidth = 3.0
        undoButton.enabled = false
        
        colorSlider.addTarget(self, action: "willChangeColor:", forControlEvents: .TouchDown)
        colorSlider.addTarget(self, action: "isChangingColor:", forControlEvents: .ValueChanged)
        colorSlider.addTarget(self, action: "didChangeColor:", forControlEvents: .TouchUpOutside)
        colorSlider.addTarget(self, action: "didChangeColor:", forControlEvents: .TouchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Colors
    @IBAction func blackColor () {
        drawingView.lineColor = UIColor.blackColor()
    }
    
    @IBAction func willChangeColor(slider: ColorSlider) {
        updateColorViews(slider.color)
        drawingView.userInteractionEnabled = false
    }
    
    @IBAction func isChangingColor(slider: ColorSlider) {
        updateColorViews(slider.color)
        drawingView.lineColor = slider.color
    }
    
    @IBAction func didChangeColor(slider: ColorSlider) {
        updateColorViews(slider.color)
        drawingView.userInteractionEnabled = true
    }
    
    func updateColorViews(color: UIColor) {
        selectedColorView.backgroundColor = color
        drawingView.lineColor = color
    }
    
    // MARK: ACEDrawingView Delegate
    func drawingView(view: ACEDrawingView, didEndDrawUsingTool tool: AnyObject) {
        undoButton.enabled = drawingView.canUndo()
    }
    
    // MARK: Actions
    @IBAction func undo () {
        drawingView.undoLatestStep()
        undoButton.enabled = drawingView.canUndo()
    }
    
    @IBAction func share () {
        var trimmedImage = drawingView.image.imageByTrimmingTransparentPixels()
        var controller = UIActivityViewController(activityItems: [trimmedImage], applicationActivities: nil)
		controller.completionWithItemsHandler = {
			activityType, completed, returnedItems, activityError in
			if completed {
				self.drawingView.clear()
				self.drawingView.lineColor = UIColor.blackColor()
				self.selectedColorView.backgroundColor = UIColor.blackColor()
			}
		}
        self.presentViewController(controller, animated: true, completion: nil)
    }
}


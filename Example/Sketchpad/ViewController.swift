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
import ACEDrawingView
import UIImageTrim

class ViewController: UIViewController, ACEDrawingViewDelegate {
	let drawingView: ACEDrawingView
	let colorSlider: ColorSlider
	
	let toolbar: UIToolbar
	var undoItem: UIBarButtonItem
	var shareItem: UIBarButtonItem
	let selectedColorView: UIView
	let selectedColorItem: UIBarButtonItem
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		drawingView = ACEDrawingView()
		colorSlider = ColorSlider()
		
		toolbar = UIToolbar()
		undoItem = UIBarButtonItem()
		shareItem = UIBarButtonItem()
		selectedColorView = UIView()
		selectedColorItem = UIBarButtonItem(customView: selectedColorView)
		
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) is not supported")
	}
	
	func commonInit() {
		drawingView.delegate = self
		drawingView.lineWidth = 3.0
		view.addSubview(drawingView)
		
		colorSlider.previewEnabled = true
		colorSlider.orientation = .vertical
		colorSlider.addTarget(self, action: #selector(ViewController.willChangeColor(_:)), for: .touchDown)
		colorSlider.addTarget(self, action: #selector(ViewController.isChangingColor(_:)), for: .valueChanged)
		colorSlider.addTarget(self, action: #selector(ViewController.didChangeColor(_:)), for: .touchUpOutside)
		colorSlider.addTarget(self, action: #selector(ViewController.didChangeColor(_:)), for: .touchUpInside)
		view.addSubview(colorSlider)
		
		undoItem = UIBarButtonItem(title: "Undo", style: .plain, target: self, action: #selector(ViewController.undo))
		shareItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(ViewController.share))
		
		let flexibleSpacingItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		undoItem.isEnabled = false
		selectedColorView.backgroundColor = UIColor.black
		selectedColorItem.width = 30
		toolbar.items = [undoItem, flexibleSpacingItem, selectedColorItem, flexibleSpacingItem, shareItem]
		view.addSubview(toolbar)
	}

    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		let colorSliderWidth = CGFloat(12)
		let colorSliderHeight = CGFloat(150)
		let colorSliderPadding = CGFloat(15)
		drawingView.frame = view.bounds
		colorSlider.frame = CGRect(x: view.bounds.width - colorSliderWidth - colorSliderPadding, y: 20 + colorSliderPadding, width: colorSliderWidth, height: colorSliderHeight)
		toolbar.frame = CGRect(x: 0, y: view.bounds.height - 44, width: view.bounds.width, height: 44)

		selectedColorView.frame = CGRect(x: 0, y: 0, width: selectedColorItem.width, height: selectedColorItem.width)
		selectedColorView.layer.cornerRadius = selectedColorView.frame.width / 2.0
		selectedColorView.layer.borderColor = UIColor.black.withAlphaComponent(0.3).cgColor
		selectedColorView.layer.borderWidth = 1.0
		selectedColorView.clipsToBounds = true
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	
    // MARK: - ColorSlider Events
    func willChangeColor(_ slider: ColorSlider) {
        drawingView.isUserInteractionEnabled = false
    }
    
   	func isChangingColor(_ slider: ColorSlider) {
        // Respond to a change in color.
    }
    
    func didChangeColor(_ slider: ColorSlider) {
        updateColorViews(slider.color)
        drawingView.isUserInteractionEnabled = true
    }
    
    func updateColorViews(_ color: UIColor) {
        selectedColorView.backgroundColor = color
        drawingView.lineColor = color
    }
	
	
    // MARK: - ACEDrawingView Delegate
    func drawingView(_ view: ACEDrawingView, didEndDrawUsingTool tool: AnyObject) {
        updateButtons()
    }
    
    // MARK: - Actions
	func undo() {
        drawingView.undoLatestStep()
        updateButtons()
    }
	
	func updateButtons() {
		undoItem.isEnabled = drawingView.canUndo()
		shareItem.isEnabled = drawingView.canUndo()
	}
    
	func share() {
        let trimmedImage = drawingView.image.trimmingTransparentPixels()
        let controller = UIActivityViewController(activityItems: [trimmedImage!], applicationActivities: nil)
		controller.completionWithItemsHandler = {
			activityType, completed, returnedItems, activityError in
			if completed {
				self.drawingView.clear()
				self.drawingView.lineColor = UIColor.black
				self.selectedColorView.backgroundColor = UIColor.black
				self.updateButtons()
			}
		}
		controller.popoverPresentationController?.barButtonItem = shareItem
		present(controller, animated: true, completion: nil)
    }
}

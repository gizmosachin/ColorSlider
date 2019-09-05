//
//  DemoView.swift
//  ColorSliderDemo
//
//  Created by Sachin Patel on 9/7/17.
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
import SpriteKit

class DemoView: UIView {
	private let colorSlider: ColorSlider
	private let label: UILabel
	
	private var particleEmitter: SKEmitterNode?
		
	override init(frame: CGRect) {
		// Set up ColorSlider and label
		colorSlider = ColorSlider(orientation: .vertical, previewSide: .left)
		label = UILabel()
		
		super.init(frame: frame)
		
		backgroundColor = .black
		
		// Only add particle emitter on device (lags on iOS simulator).
		#if !(arch(i386) || arch(x86_64))
			setupParticleEmitter()
		#endif
		
		// Set up and add the label
		label.textColor = .white
		label.text = "ColorSlider"
		label.textAlignment = .center
		label.font = UIFont.systemFont(ofSize: 100, weight: .bold)
		label.adjustsFontSizeToFitWidth = true
		addSubview(label)
		
		// Observe ColorSlider events
		colorSlider.addTarget(self, action: #selector(changedColor(slider:)), for: .valueChanged)
		addSubview(colorSlider)
		
		setupConstraints()
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// Set up the particle emitter in the background.
	// This is totally unnecessary for ColorSlider but makes for a fun demo.
	func setupParticleEmitter() {
		let particleView = SKView()
		guard let emitter = SKEmitterNode(fileNamed: "Spark.sks") else { return }
		
		emitter.particleColorBlendFactor = 1
		emitter.particleColorSequence = nil
		emitter.particleColor = .red
		addSubview(particleView)
		
		let scene = SKScene(size: UIScreen.main.bounds.size)
		scene.scaleMode = .aspectFill
		scene.backgroundColor = .clear
		
		emitter.position = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.height * 0.6)
		scene.addChild(emitter)
		particleView.presentScene(scene)
		
		particleView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			particleView.leftAnchor.constraint(equalTo: leftAnchor),
			particleView.rightAnchor.constraint(equalTo: rightAnchor),
			particleView.topAnchor.constraint(equalTo: topAnchor),
			particleView.bottomAnchor.constraint(equalTo: bottomAnchor),
		])
		
		particleEmitter = emitter
	}
	
	// Set up view constraints.
	func setupConstraints() {
		let inset = CGFloat(30)
		let colorSliderHeight = CGFloat(150)
		label.translatesAutoresizingMaskIntoConstraints = false
		colorSlider.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			colorSlider.centerXAnchor.constraint(equalTo: centerXAnchor),
			colorSlider.bottomAnchor.constraint(equalTo: centerYAnchor),
			colorSlider.widthAnchor.constraint(equalToConstant: 15),
			colorSlider.heightAnchor.constraint(equalToConstant: colorSliderHeight),
			
			label.leftAnchor.constraint(equalTo: leftAnchor, constant: inset),
			label.rightAnchor.constraint(equalTo: rightAnchor, constant: -inset),
			label.topAnchor.constraint(equalTo: colorSlider.bottomAnchor, constant: inset),
			label.heightAnchor.constraint(equalToConstant: 100),
		])
	}
	
	// Observe ColorSlider .valueChanged events.
	@objc func changedColor(slider: ColorSlider) {
		label.textColor = slider.color
		particleEmitter?.particleColor = slider.color
	}
}

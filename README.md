## ColorSlider

`ColorSlider` is a Snapchat-style color picker written in [Swift](https://developer.apple.com/swift/). It supports changing color hue when dragging inside the bounds of the control and modifying color lightness when dragging outside its bounds, allowing you to select black and white.

![ColorSlider](https://raw.githubusercontent.com/gizmosachin/ColorSlider/master/ColorSlider.gif)

![Pod Version](https://img.shields.io/cocoapods/v/ColorSlider.svg) [![Build Status](https://travis-ci.org/gizmosachin/ColorSlider.svg?branch=master)](https://travis-ci.org/gizmosachin/ColorSlider)

## Installation

### CocoaPods

`ColorSlider` is available for installation using [CocoaPods](http://cocoapods.org/). To integrate, add the following to your Podfile`:

``` ruby
platform :ios, '9.0'
use_frameworks!

pod 'ColorSlider', '~> 2.2'
```

### Carthage

`ColorSlider` is also available for installation using [Carthage](https://github.com/Carthage/Carthage). To integrate, add the following to your `Cartfile`:

``` odgl
github "gizmosachin/ColorSlider" >= 2.2
```

### Swift Package Manager

`ColorSlider` is also available for installation using the [Swift Package Manager](https://swift.org/package-manager/). Add the following to your `Package.swift`:

``` swift
import PackageDescription

let package = Package(
    name: "MyProject",
    dependencies: [
        .Package(url: “https://github.com/gizmosachin/ColorSlider.git”, majorVersion: 0),
    ]
)
```

### Manual

You can also simply copy the `ColorSlider.swift` file into your Xcode project.

## Usage

The sample project `Sketchpad` provides an example of how to integrate `ColorSlider` with Interface Builder, but you can also follow the steps below. `ColorSlider` has several `IBInspectable` appearance properties that you can edit right from Interface Builder, if you choose to go that route.

Create and add an instance of `ColorSlider` to your view hierarchy.

``` Swift
let colorSlider = ColorSlider()
colorSlider.frame = CGRectMake(0, 0, 10, 150)
view.addSubview(colorSlider)
```

`ColorSlider` is a subclass of `UIControl` and supports the following `UIControlEvents`:

- `.TouchDown`
- `.ValueChanged`
- `.TouchUpInside`
- `.TouchUpOutside`
- `.TouchCancel`

You can get the currently selected color with the `color` property.

``` Swift
colorSlider.addTarget(self, action: "changedColor:", forControlEvents: UIControlEvents.ValueChanged)

func changedColor(slider: ColorSlider) {
    var myColor = slider.color
    // ...
}
```

Enable live color preview:

``` swift
colorSlider.previewEnabled = true
```

Customize appearance attributes:

``` Swift
colorSlider.cornerRadius = 2.0
colorSlider.borderWidth = 2.0
colorSlider.borderColor = UIColor.whiteColor()
colorSlider.edgeInsets = UIEdgeInsetsMake(0.0, 20.0, 0.0, 20.0)
```

## Sketchpad

`ColorSlider` comes with an example project called `Sketchpad`, a simple drawing app. To try it, install [CocoaPods](http://cocoapods.org/) and run `pod install` under the `Example` directory. Then, open `Example > Sketchpad.xcworkspace`.

## How it Works

`ColorSlider` uses [HSL](http://en.wikipedia.org/wiki/HSL_and_HSV) and defaults to saturation 100% and lightness: 50%. Dragging up and down modifies the color hue. When you slide your finger outside the bounds of the `ColorSlider`, you can modify the lightness of the color, allowing you to select black and white.

## License

ColorSlider is available under the MIT license, see the [LICENSE](https://github.com/gizmosachin/ColorSlider/blob/master/LICENSE) file for more information.
## ColorSlider

`ColorSlider` is a Snapchat-style color picker written in [Swift](https://developer.apple.com/swift/). It supports changing color hue when dragging inside the bounds of the `ColorSlider` and modifying lightness when dragging outside its bounds, allowing you to select black and white.

## Installation

`ColorSlider` is available for installation using a [pre-release](http://blog.cocoapods.org/Pod-Authors-Guide-to-CocoaPods-Frameworks/) version of [CocoaPods](http://cocoapods.org/), which you can install with `sudo gem install cocoapods --pre` in Terminal.

```ruby
pod 'ColorSlider', :git => 'https://github.com/gizmosachin/ColorSlider'
```	

You can also simply copy the `ColorSlider.swift` file into your Xcode project.

## Usage

The sample project `Sketchpad` provides an example of how to integrate `ColorSlider`, but you can also follow the steps below.

Create and add an instance of `ColorSlider` to your view hierarchy.

``` Swift
self.colorSlider = ColorSlider()
self.colorSlider.frame = CGRectMake(0, 0, 10, 150)
self.view.addSubview(self.colorSlider)
```


`ColorSlider` is a subclass of `UIControl` and supports the following `UIControlEvents`:
- `TouchDown`
- `ValueChanged`
- `TouchUpInside`
- `TouchUpOutside`

You can get the currently selected color with the `color` property.

``` Swift
self.colorSlider.addTarget(self, action: "changedColor:", forControlEvents: UIControlEvents.ValueChanged)

func changedColor(slider: ColorSlider) {
    var myColor = slider.color
    // ...
}
```


Customize border attributes:

``` Swift
self.colorSlider.cornerRadius = 2.0
self.colorSlider.borderWidth = 2.0
self.colorSlider.borderColor = UIColor.whiteColor()
```


To make it easier to select colors, you can specify padding around the bounds of the `ColorSlider` in which touch input will still edit the color hue.

``` Swift
self.colorSlider.padding = 44.0
```

## Sketchpad

`ColorSlider` comes with a demo project called `Sketchpad` that's a simple drawing app for iPhone. To get it to run in Xcode, you must run `pod install`. Note that this does not require the pre-release version (0.36) of Cocoapods.

## How it Works

`ColorSlider` uses [HSL](http://en.wikipedia.org/wiki/HSL_and_HSV), defaults to saturation: 100% / lightness: 50%, and allows you to modify the hue by sliding up and down. When you slide your finger outside the bounds (+ padding) of the `ColorSlider`, you can modify the lightness of the color, allowing you to select black and white.

## License

ColorSlider is available under the MIT license, see the [LICENSE](https://github.com/gizmosachin/ColorSlider/blob/master/LICENSE) file for more information.


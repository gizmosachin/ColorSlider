# ColorSlider

ColorSlider is an iOS color picker with live preview written in [Swift](https://developer.apple.com/swift/).

![ColorSlider](https://raw.githubusercontent.com/gizmosachin/ColorSlider/master/ColorSlider.gif)

[![Build Status](https://travis-ci.org/gizmosachin/ColorSlider.svg?branch=master)](https://travis-ci.org/gizmosachin/ColorSlider) ![Pod Version](https://img.shields.io/cocoapods/v/ColorSlider.svg) [![Swift Version](https://img.shields.io/badge/language-swift%204.0-brightgreen.svg)](https://developer.apple.com/swift) [![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://github.com/gizmosachin/ColorSlider/blob/master/LICENSE)

|  | Features |
|:---------:|:---------------------------------------------------------------|
| &#128123; | "[Snapchat](http://snapchat.com)-style" color picker |
| &#127912; | Extensible live preview |
| &#127744; | Customizable appearance |
| &#127929; | Black and white colors included |
| &#128214; | Fully [documented](http://gizmosachin.github.io/ColorSlider) |
| &#128038; | [Swift 4](https://developer.apple.com/swift/) |

## Usage

Create and add a ColorSlider to your view:

``` Swift
let colorSlider = ColorSlider(orientation: .vertical, previewSide: .left)
colorSlider.frame = CGRectMake(0, 0, 12, 150)
view.addSubview(colorSlider)
```

Respond to changes in color using `UIControlEvents`:

``` Swift
colorSlider.addTarget(self, action: #selector(changedColor(_:)), forControlEvents: .valueChanged)

func changedColor(_ slider: ColorSlider) {
    var color = slider.color
    // ...
}
```

Customize appearance attributes:

``` Swift
// Add a border
colorSlider.gradientView.layer.borderWidth = 2.0
colorSlider.gradientView.layer.borderColor = UIColor.white

// Disable rounded corners
colorSlider.gradientView.automaticallyAdjustsCornerRadius = false
```

### Preview

`ColorSlider` has a live preview that tracks touches along it. You can customize it:

``` Swift
let previewView = ColorSlider.DefaultPreviewView()
previewView.side = .right
previewView.animationDuration = 0.2
previewView.offsetAmount = 50

let colorSlider = ColorSlider(orientation: .vertical, previewView: previewView)
```

Create your own live preview by subclassing `DefaultPreviewView` or implementing `ColorSliderPreviewing` in your `UIView` subclass.
Then, just pass your preview instance to the initializer:
``` Swift
let customPreviewView = MyCustomPreviewView()
let colorSlider = ColorSlider(orientation: .vertical, previewView: customPreviewView)
```
ColorSlider will automatically update your view's `center` as touches move on the slider. 
By default, it'll also resize your preview automatically. Set `colorSlider.autoresizesSubviews` to `false` to disable autoresizing.

To disable the preview, simply pass `nil` to ColorSlider's initializer:
``` Swift
let colorSlider = ColorSlider(orientation: .vertical, previewView: nil)
```

See the [documentation](http://gizmosachin.github.io/ColorSlider) for more details on custom previews.

### Documentation

ColorSlider is fully documented [here](http://gizmosachin.github.io/ColorSlider).

## Installation

### [CocoaPods](https://cocoapods.org/)

``` ruby
platform :ios, '9.0'
pod 'ColorSlider', '~> 4.0'
```

### [Carthage](https://github.com/Carthage/Carthage)

``` odgl
github "gizmosachin/ColorSlider" >= 4.0
```

## Version Compatibility

| Swift Version | Framework Version |
| ------------- | ----------------- |
| 4.0	        | master         	|
| 3.0	        | 3.0.1          	|

## Samples

Please see the `Samples` directory for a sample playground and iOS project that integrate `ColorSlider`.

## Contributing

ColorSlider is a community - contributions and discussions are welcome!

Please read the [contributing guidelines](https://github.com/gizmosachin/ColorSlider/blob/master/Contributing.md) prior to submitting a Pull Request.

## License

ColorSlider is available under the MIT license, see the [LICENSE](https://github.com/gizmosachin/ColorSlider/blob/master/LICENSE) file for more information.

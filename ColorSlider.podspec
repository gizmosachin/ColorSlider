Pod::Spec.new do |s|
  s.name         = 'ColorSlider'
  s.version      = '1.1'
  s.summary      = 'iOS Snapchat-style color picker'
  s.homepage     = 'http://github.com/gizmosachin/ColorSlider'
  s.license      = 'MIT'
  s.author       = { 'Sachin Patel' => 'me@gizmosachin.com' }
  s.source       = { :git => 'https://github.com/gizmosachin/ColorSlider.git', :tag => '1.1' }
  s.platform     = :ios, '8.0'
  s.source_files = 'Source/*.swift'
  s.requires_arc = true
  s.frameworks   = 'Foundation', 'UIKit', 'CoreGraphics', 'QuartzCore'
end

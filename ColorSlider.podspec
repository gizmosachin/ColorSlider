Pod::Spec.new do |s|
  s.name = 'ColorSlider'
  s.version = '4.4'
  s.summary = 'Snapchat-style color picker in Swift'
  s.homepage = 'http://github.com/gizmosachin/ColorSlider'
  s.license = 'MIT'
  s.documentation_url = 'https://gizmosachin.github.io/ColorSlider/'

  s.social_media_url = 'http://twitter.com/gizmosachin'
  s.author = { 'Sachin Patel' => 'me@gizmosachin.com' }

  # source
  s.source = { :git => 'https://github.com/gizmosachin/ColorSlider.git', :tag => s.version }
  s.source_files = 'Sources/**', 'Sources/Internal/**'

  # platform
  s.platform = :ios
  s.ios.deployment_target = '9.0'
  s.swift_version = '5.0'

  # build settings
  s.requires_arc = true
  s.frameworks = 'Foundation', 'UIKit', 'CoreGraphics', 'QuartzCore'
end

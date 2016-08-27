#
# Be sure to run `pod lib lint YMValidator.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YMValidator'
  s.version          = '0.1.0'
  s.summary          = 'TextField Validation library for Swift (@IBDesignable & Programmatically)'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/YMonnier/YMValidator'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Ysee Monnier' => 'contact@yseemonnier.com' }
  s.source           = { :git => 'https://github.com/YMonnier/YMValidator.git', :tag => s.version.to_s }
   s.social_media_url = 'https://twitter.com/Ysee88'

  s.ios.deployment_target = '8.0'

  s.source_files = 'YMValidator/Classes/**/*'
  
  # s.resource_bundles = {
  #   'YMValidator' => ['YMValidator/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end

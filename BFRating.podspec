#
# Be sure to run `pod lib lint BFRating.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BFRating'
  s.version          = '1.0.2'
  s.summary          = 'BFRating enhances the rating process of your app. With this library you only get the most positiv ratings!'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Currently iOS has its own in app rating mechanism which works pretty well. We want to enhance this process with an alert before asking if the user is happy with the app. This will filter bad ratings and let those users write feedback via mail to the developer.
                       DESC

  s.homepage         = 'https://www.bitfactory.io/de/blog/inapp-rating/'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Matthias Nagel' => 'matthias@bitfactory.io' }
  s.source           = { :git => 'https://github.com/bitfactoryio/BFRating.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/bitfactoryio'
  s.swift_version = '4.0'

  s.ios.deployment_target = '11.0'

  s.source_files = 'BFRating/Classes/**/*'
  
  # s.resource_bundles = {
  #   'BFRating' => ['BFRating/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'SwiftyUserDefaults'
  s.dependency 'Localize-Swift'
end

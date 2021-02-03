Pod::Spec.new do |s|
  s.name             = 'BFRating'
  s.version          = '1.0.4'
  s.summary          = 'BFRating enhances the rating process of your app. With this library you only get the most positiv ratings!'

  s.description      = <<-DESC
  Currently iOS has its own in app rating mechanism which works pretty well. We want to enhance this process with an alert before asking if the user is happy with the app. This will filter bad ratings and let those users write feedback via mail to the developer.
                       DESC

  s.homepage         = 'https://www.bitfactory.io/de/blog/inapp-rating/'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Matthias Nagel' => 'matthias@bitfactory.io' }
  s.source           = { :git => 'https://github.com/bitfactoryio/BFRating.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/bitfactoryio'
  s.swift_version = '5.1'

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

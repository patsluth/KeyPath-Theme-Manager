#
# Be sure to run `pod lib lint KeyPath-Theme-Manager.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KeyPath-Theme-Manager'
  s.version          = '0.1.0'
  s.summary          = 'A short description of KeyPath-Theme-Manager.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/patsluth/KeyPath-Theme-Manager'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'patsluth' => 'pat.sluth@gmail.com' }
  s.source           = { :git => 'https://github.com/patsluth/KeyPath-Theme-Manager.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/patsluth'

  s.ios.deployment_target = '8.0'
  s.swift_version = '4.2'

  s.source_files = 'KeyPath-Theme-Manager/Classes/**/*',
  'KeyPath-Theme-Manager/Classes/Sluthware/**/*'
  
  # s.resource_bundles = {
  #   'KeyPath-Theme-Manager' => ['KeyPath-Theme-Manager/Assets/*.png']
  # }

  s.frameworks = 'UIKit'

end

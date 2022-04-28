#
# Be sure to run `pod lib lint Dependiject.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Dependiject'
  s.version          = '0.1.0'
  s.summary          = 'Dependiject provides simple and flexible dependency injection for testability and inversion of control in SwiftUI apps.'

  s.homepage         = 'https://github.com/Tiny-Home-Consulting/Dependiject'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MPL-2.0', :file => 'LICENSE' }
  s.authors          = { 'William Baker' => 'bbrk24@gmail.com',
                         'Liam Gleeson' => 'ljgleeson2106@gmail.com',
                         'Wesley Boyd' => 'u4qr@protonmail.com' }
  s.source           = { :git => 'https://github.com/Tiny-Home-Consulting/Dependiject.git', :tag => s.version }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'
  s.osx.deployment_target = '10.15'
  s.watchos.deployment_target = '6.0'
  s.tvos.deployment_target = '13.0'

  s.cocoapods_version = '~> 1.10'
  s.swift_versions = '5.4'
  s.source_files = 'Dependiject/**/*.swift'

  s.frameworks = 'SwiftUI', 'Combine'
  # s.dependency 'AFNetworking', '~> 2.3'
end

#
# Be sure to run `pod lib lint Dependiject.podspec' to ensure this is a
# valid spec before submitting.
#

Pod::Spec.new do |s|
    s.name = 'Dependiject'
    s.version = '1.1.0'
    s.summary = 'Dependiject provides simple, flexible, and thread-safe dependency injection for testability and inversion of control in SwiftUI apps.'
    
    s.homepage = 'https://github.com/Tiny-Home-Consulting/Dependiject'
    s.license = { :type => 'MPL-2.0', :file => 'LICENSE' }
    s.documentation_url = 'https://dependiject.tinyhomeconsultingllc.com/documentation/'
    
    s.authors = {
        'William Baker' => 'bbrk24@gmail.com',
        'Liam Gleeson' => 'ljgleeson2106@gmail.com',
        'Wesley Boyd' => 'u4qr@protonmail.com'
    }
    
    s.source = {
        :git => 'https://github.com/Tiny-Home-Consulting/Dependiject.git',
        :tag => s.version
    }
    
    s.ios.deployment_target = '15.0'
    s.osx.deployment_target = '12.0'
    s.watchos.deployment_target = '9.0'
    s.tvos.deployment_target = '15.0'
    s.visionos.deployment_target = '1.0'
    
    s.cocoapods_version = '~> 1.16'
    s.swift_versions = '6'
    s.source_files = 'Dependiject/**/*.swift'
    
    s.frameworks = 'SwiftUI', 'Combine'
end

#
# Be sure to run `pod lib lint Dependiject.podspec' to ensure this is a
# valid spec before submitting.
#

Pod::Spec.new do |s|
    s.name = 'Dependiject'
    s.version = '0.3.0'
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
    
    s.ios.deployment_target = '13.0'
    s.osx.deployment_target = '10.15'
    s.watchos.deployment_target = '6.0'
    s.tvos.deployment_target = '13.0'
    
    s.cocoapods_version = '>= 1.11.3'
    s.swift_versions = '5.5'
    s.source_files = 'Dependiject/**/*.swift'
    
    s.frameworks = 'SwiftUI', 'Combine'
end

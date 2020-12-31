Pod::Spec.new do |s|
    s.name                      = "FlyoverKit"
    s.version                   = "1.3.1"
    s.summary                   = "360° flyover on an MKMapView"
    s.homepage                  = "https://github.com/SvenTiigi/FlyoverKit"
    s.social_media_url          = 'http://twitter.com/SvenTiigi'
    s.license                   = 'MIT'
    s.author                    = { "Sven Tiigi" => "sven.tiigi@gmail.com" }
    s.source                    = { :git => "https://github.com/SvenTiigi/FlyoverKit.git", :tag => s.version.to_s }
    s.swift_version             = "5.0"
    s.ios.deployment_target     = "10.0"
    s.source_files              = 'Sources/**/*'
    s.frameworks                = 'Foundation', 'UIKit', 'MapKit'
    s.default_subspecs = "Core"
    
    s.subspec "Core" do |sp|
        sp.source_files  = ["Sources/**/*"]
        sp.exclude_files = ["Sources/SwiftUI/**"]
    end

    s.subspec "SwiftUI" do |sp|
        sp.source_files = ["Sources/SwiftUI/**"]
        sp.dependency "FlyoverKit/Core"
        sp.ios.deployment_target = "13.0"
        sp.pod_target_xcconfig = { 'OTHER_SWIFT_FLAGS' => '-DFlyoverKitCocoaPods' }
    end
end

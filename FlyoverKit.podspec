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
    s.tvos.deployment_target    = "10.0"
    s.requires_arc              = true
    s.source_files              = 'Sources/**/*'
    s.frameworks                = 'UIKit', 'MapKit'
end

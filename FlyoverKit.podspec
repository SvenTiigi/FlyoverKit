Pod::Spec.new do |s|
    s.name             = "FlyoverKit"
    s.version          = "1.1.0"
    s.summary          = "Flyover Camera for iOS MapView"
    s.homepage         = "https://github.com/SvenTiigi/FlyoverKit"
    s.social_media_url = 'http://twitter.com/SvenTiigi'
    s.license          = 'MIT'
    s.author           = { "Sven Tiigi" => "sven.tiigi@gmail.com" }
    s.source           = { :git => "https://github.com/SvenTiigi/FlyoverKit.git", :tag => s.version.to_s }
    s.platform         = :ios, '10.0'
    s.requires_arc     = true
    s.source_files     = 'FlyoverKit/**/*'
    s.frameworks       = 'UIKit', 'MapKit'
end

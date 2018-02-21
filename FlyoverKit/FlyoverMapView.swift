//
//  FlyoverMapView.swift
//  FlyoverKit
//
//  Created by Sven Tiigi on 21.02.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import MapKit

// MARK: - FlyoverMapView

/// The FlyoverMapView
open class FlyoverMapView: MKMapView {
    
    // MARK: Properties
    
    /// The FlyoverCamera
    open lazy var flyoverCamera: FlyoverCamera = {
        return FlyoverCamera(mapView: self, configurationTheme: .default)
    }()
    
    /// The FlyoverMapView MapType
    open var flyoverMapType: MapType {
        set {
            // Set mapType rawValue
            self.mapType = newValue.rawValue
        }
        get {
            // Return MapType constructed with MKMapType otherwise return standard
            return MapType(rawValue: self.mapType) ?? .standard
        }
    }
    
    /// The FlyoverCamera Configuration computed property for easy access
    open var configuration: FlyoverCamera.Configuration {
        set {
            // Set new value
            self.flyoverCamera.configuration = newValue
        }
        get {
            // Return FlyoverCamera configuration
            return self.flyoverCamera.configuration
        }
    }
    
    /// Retrieve boolean if the FlyoverCamera is started
    open var isStarted: Bool {
        // Return FlyoverCamera isStarted property
        return self.flyoverCamera.isStarted
    }
    
    // MARK: Initializer
    
    /// Default initializer with flyover configuration and map type
    ///
    /// - Parameters:
    ///   - configuration: The flyover configuration
    ///   - mapType: The map type
    public init(configuration: FlyoverCamera.Configuration, mapType: MapType = .standard) {
        super.init(frame: .zero)
        // Set the configuration
        self.flyoverCamera.configuration = configuration
        // Set flyover map type
        self.flyoverMapType = mapType
        // Hide compass
        self.showsCompass = false
        // Show buildings
        self.showsBuildings = true
        // Disable userInteraction
        self.isUserInteractionEnabled = false
    }
    
    /// Convenience initializer with flyover configuration theme and map type
    ///
    /// - Parameters:
    ///   - configurationTheme: The flyover configuration theme
    ///   - mapType: The map type
    public convenience init(configurationTheme: FlyoverCamera.Configuration.Theme, mapType: MapType = .standard) {
        self.init(configuration: configurationTheme.rawValue, mapType: mapType)
    }
    
    /// Initializer with NSCoder (not supported) returns nil
    required public init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    /// Deinit
    deinit {
        // Stop FlyoverCamera
        self.stop()
    }
    
    // MARK: Convenience start/stop functions
    
    /// Start flyover with MKAnnotation and the optional region change animation mode.
    ///
    /// - Parameters:
    ///   - annotation: The MKAnnotation
    ///   - regionChangeAnimationMode: The region change animation mode (Default: none)
    open func start(annotation: MKAnnotation, regionChangeAnimationMode: FlyoverCamera.RegionChangeAnimationMode = .none) {
        self.start(flyover: annotation.coordinate, regionChangeAnimationMode: regionChangeAnimationMode)
    }
    
    /// Start flyover with FlyoverAble and the optional region change animation mode.
    ///
    /// - Parameters:
    ///   - flyover: The Flyover object (e.g. CLLocationCoordinate2D, CLLocation, MKMapPoint)
    ///   - regionChangeAnimationMode: The region change animation mode (Default: none)
    open func start(flyover: Flyover, regionChangeAnimationMode: FlyoverCamera.RegionChangeAnimationMode = .none) {
        self.flyoverCamera.start(flyover: flyover, regionChangeAnimationMode: regionChangeAnimationMode)
    }
    
    /// Stop Flyover
    open func stop() {
        self.flyoverCamera.stop()
    }
    
}

// MARK: - SupportedMapType

public extension FlyoverMapView {
    
    /// The FlyoverMapView supported MapType
    enum MapType {
        /// Standard
        case standard
        /// Satellite Flyover
        case satelliteFlyover
        /// Hybrid Flyover
        case hybridFlyover
    }
    
}

// MARK: - SupportedMapType RawRepresentable

extension FlyoverMapView.MapType: RawRepresentable {
    
    /// Associated type RawValue as MKMapType
    public typealias RawValue = MKMapType
    
    /// RawRepresentable initializer
    ///
    /// - Parameters:
    ///   - rawValue: The MapType
    public init?(rawValue: RawValue) {
        // Switch on rawValue
        switch rawValue {
        case .standard:
            self = .standard
        case .satelliteFlyover:
            self = .satelliteFlyover
        case .hybridFlyover:
            self = .hybridFlyover
        default:
            return nil
        }
    }
    
    /// The MKMapType
    public var rawValue: RawValue {
        // Switch on self
        switch self {
        case .standard:
            return .standard
        case .satelliteFlyover:
            return .satelliteFlyover
        case .hybridFlyover:
            return .hybridFlyover
        }
    }
    
}

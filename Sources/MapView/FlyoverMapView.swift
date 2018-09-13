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
        return FlyoverCamera(mapView: self)
    }()
    
    /// The FlyoverMapView MapType
    open var flyoverMapType: MapType? {
        set {
            // Set mapType rawValue
            newValue.flatMap { self.mapType = $0.rawValue }
        }
        get {
            // Return MapType constructed with MKMapType otherwise return standard
            return MapType(rawValue: self.mapType)
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
    
    /// Retrieve FlyoverCamera state
    open var state: FlyoverCamera.State {
        // Return FlyoverCamera state property
        return self.flyoverCamera.state
    }
    
    // MARK: Initializer
    
    /// Default initializer with flyover configuration and map type
    ///
    /// - Parameters:
    ///   - configuration: The flyover configuration. Default value: `.default` theme
    ///   - mapType: The map type. Default value: `.standard` type
    public init(configuration: FlyoverCamera.Configuration = .default,
                mapType: MapType = .standard) {
        super.init(frame: .zero)
        // Set the configuration
        self.flyoverCamera.configuration = configuration
        // Set flyover map type
        self.flyoverMapType = mapType
        // Hide compass on iOS
        #if os(iOS)
            self.showsCompass = false
        #endif
        // Show buildings
        self.showsBuildings = true
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
    open func start(annotation: MKAnnotation) {
        // Disable userInteraction
        self.isUserInteractionEnabled = false
        // Start flyover with annotation coordinate
        self.start(flyover: annotation.coordinate)
    }
    
    /// Start flyover with FlyoverAble and the optional region change animation mode.
    ///
    /// - Parameters:
    ///   - flyover: The Flyover object (e.g. CLLocationCoordinate2D, CLLocation, MKMapPoint)
    open func start(flyover: Flyover) {
        // Disable userInteraction
        self.isUserInteractionEnabled = false
        // Start flyover
        self.flyoverCamera.start(flyover: flyover)
    }
    
    /// Stop Flyover
    open func stop() {
        // Stop FlyoverCamera
        self.flyoverCamera.stop()
        // Enable userInteraction
        self.isUserInteractionEnabled = true
    }
    
}

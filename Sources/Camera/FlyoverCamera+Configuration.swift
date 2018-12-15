//
//  FlyoverCamera+Configuration.swift
//  FlyoverKit
//
//  Created by Sven Tiigi on 21.02.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import CoreLocation

// MARK: - Configuration

public extension FlyoverCamera {
    
    /// The FlyoverCamera Configuration
    struct Configuration: Equatable, Hashable {
        
        /// The duration
        public var duration: TimeInterval
        
        /// The altitude above the ground, measured in meters
        public var altitude: CLLocationDistance
        
        /// The viewing angle of the camera, measured in degrees
        public var pitch: Double
        
        /// The heading step
        public var headingStep: CLLocationDirection
        
        /// The region change animation
        public var regionChangeAnimation: RegionChangeAnimation
        
        /// Default initializer
        ///
        /// - Parameters:
        ///   - duration: The duration
        ///   - altitude: The altitude
        ///   - pitch: The pitch
        ///   - headingStep: The heading step
        ///   - regionChangeAnimation: The region change animation. Default value `none`
        public init(duration: TimeInterval,
                    altitude: CLLocationDistance,
                    pitch: Double,
                    headingStep: Double,
                    regionChangeAnimation: RegionChangeAnimation = .none) {
            self.duration = duration
            self.altitude = altitude
            self.pitch = pitch
            self.headingStep = headingStep
            self.regionChangeAnimation = regionChangeAnimation
        }
    }
    
}

// MARK: - Configuration Theme

public extension FlyoverCamera.Configuration {
    
    /// Default configuration
    static let `default` = FlyoverCamera.Configuration(
        duration: 4.0,
        altitude: 600,
        pitch: 45.0,
        headingStep: 20.0
    )
    
    /// Low flying configuration
    static let lowFlying = FlyoverCamera.Configuration(
        duration: 4.0,
        altitude: 65,
        pitch: 80,
        headingStep: 20
    )
    
    /// Far away configuration
    static let farAway = FlyoverCamera.Configuration(
        duration: 4.0,
        altitude: 1330,
        pitch: 55,
        headingStep: 20
    )
    
    //// Giddy configuration
    static let giddy = FlyoverCamera.Configuration(
        duration: 0.0,
        altitude: 250,
        pitch: 80,
        headingStep: 50
    )
    
    /// Astronaut view configuration
    static let astronautView = FlyoverCamera.Configuration(
        duration: 20.0,
        altitude: 2000.0,
        pitch: 100.0,
        headingStep: 35.0
    )
    
}

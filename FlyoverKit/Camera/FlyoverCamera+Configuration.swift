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
    struct Configuration {
        
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
        ///   - regionChangeAnimation: The region change animation
        public init(duration: TimeInterval, altitude: CLLocationDistance, pitch: Double,
                    headingStep: Double, regionChangeAnimation: RegionChangeAnimation = .none) {
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
    
    /// The FlyoverCamera.Configuration Theme
    enum Theme {
        /// Default theme
        case `default`
        /// Low fyling theme
        case lowFlying
        /// Far away
        case farAway
        /// Spinning around (do not use in production)
        case giddy
    }
    
}

// MARK: Configuration Theme RawRepresentable

extension FlyoverCamera.Configuration.Theme: RawRepresentable {
    
    /// Associated type RawValue as Flyover.Configuration
    public typealias RawValue = FlyoverCamera.Configuration
    
    /// RawRepresentable initializer. Which always returns nil
    ///
    /// - Parameters:
    ///   - rawValue: The rawValue
    public init?(rawValue: RawValue) {
        // Returning nil to avoid constructing enum via Configuration
        return nil
    }
    
    /// The preconfigured Configuration Struct
    public var rawValue: RawValue {
        // Switch on self
        switch self {
        case .default:
            return RawValue(
                duration: 4.0,
                altitude: 600,
                pitch: 45.0,
                headingStep: 20.0
            )
        case .lowFlying:
            return RawValue(
                duration: 4.0,
                altitude: 65,
                pitch: 80,
                headingStep: 20
            )
        case .farAway:
            return RawValue(
                duration: 4.0,
                altitude: 1330,
                pitch: 55,
                headingStep: 20
            )
        case .giddy:
            return RawValue(
                duration: 0.0,
                altitude: 250,
                pitch: 80,
                headingStep: 50
            )
        }
    }
    
}

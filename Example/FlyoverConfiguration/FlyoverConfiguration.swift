//
//  Configuration.swift
//  FlyoverKit-Example
//
//  Created by Sven Tiigi on 21.02.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import Foundation
import MapKit

// MARK: - Configuration

/// The FlyoverConfiguration Enumeration
enum FlyoverConfiguration {
    
    /// Flyover start/stop boolean
    case flyover(Bool)
    /// The mapType
    case mapType(MKMapType)
    /// The duration
    case duration(Double)
    /// The altitude
    case altitude(Double)
    /// The pitch
    case pitch(Double)
    /// The heading step
    case headingStep(Double)

    /// Retrieve the Display Name for the Configuration
    ///
    /// - Returns: The display name string
    func getDisplayName() -> String {
        switch self {
        case .flyover:
            return "Flyover"
        case .mapType:
            return "MapType"
        case .duration:
            return "Duration"
        case .altitude:
            return "Altitude"
        case .pitch:
            return "Pitch"
        case .headingStep:
            return "HeadingStep"
        }
    }
    
    /// Retrieve the minimum Value for Configuration case
    ///
    /// - Returns: The minimum value
    func getMinimumValue() -> Float {
        return 0
    }
    
    /// Retrieve the maximum value for Configuration case
    ///
    /// - Returns: The maximum value
    func getMaximumValue() -> Float {
        switch self {
        case .duration:
            return 50
        case .altitude:
            return 2000
        case .pitch:
            return 100
        case .headingStep:
            return 100
        default:
            return 0
        }
    }
    
}

// MARK: - RawRepresentable

extension FlyoverConfiguration: RawRepresentable {
    
    /// Associated type RawValue as String
    typealias RawValue = String
    
    /// RawRepresentable initializer. Which always returns nil
    ///
    /// - Parameters:
    ///   - rawValue: The rawValue
    init?(rawValue: String) {
        // Returning nil to avoid constructing enum with String
        return nil
    }
    
    /// The enumeration name as String
    var rawValue: RawValue {
        // Retrieve label via Mirror for Enum with associcated value
        guard let label = Mirror(reflecting: self).children.first?.label else {
            // Return String describing self enumeration with no asscoiated value
            return String(describing: self)
        }
        // Return label
        return label
    }
    
}

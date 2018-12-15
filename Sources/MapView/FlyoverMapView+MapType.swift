//
//  FlyoverMapView+MapType.swift
//  FlyoverKit
//
//  Created by Sven Tiigi on 21.02.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import MapKit

// MARK: - MapType

public extension FlyoverMapView {
    
    /// The FlyoverMapView supported MapType
    enum MapType: String, Equatable, Hashable, CaseIterable {
        /// Standard
        case standard
        /// Satellite Flyover
        case satelliteFlyover
        /// Hybrid Flyover
        case hybridFlyover
    }
    
}

// MARK: - MapType RawRepresentable

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

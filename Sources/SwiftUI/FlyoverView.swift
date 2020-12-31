//
//  FlyoverView.swift
//  FlyoverKitSwiftUI
//
//  Created by Sven Tiigi on 31.12.20.
//  Copyright © 2020 FlyoverKit. All rights reserved.
//

#if canImport(SwiftUI)

import SwiftUI

#if !FlyoverKitCocoaPods
import FlyoverKit
#endif

// MARK: - FlyoverView

/// The FlyoverView
public struct FlyoverView: View {
    
    // MARK: Properties
    
    /// The `FlyoverCamera.Configuration`
    public let configuration: FlyoverKit.FlyoverCamera.Configuration
    
    /// The `FlyoverMapView.MapType`
    public let mapType: FlyoverKit.FlyoverMapView.MapType
    
    /// The `Flyover`
    public let flyover: FlyoverKit.Flyover?
    
    // MARK: Initializer
    
    /// Designated Initializer
    /// - Parameters:
    ///   - configuration: The `FlyoverCamera.Configuration`. Default value `.default`
    ///   - mapType: The `FlyoverMapView.MapType`. Default value `.standard`
    ///   - flyover: The optional `Flyover`
    public init(
        configuration: FlyoverKit.FlyoverCamera.Configuration = .default,
        mapType: FlyoverKit.FlyoverMapView.MapType = .standard,
        flyover: FlyoverKit.Flyover?
    ) {
        self.configuration = configuration
        self.mapType = mapType
        self.flyover = flyover
    }
    
}

// MARK: - UIViewRepresentable

extension FlyoverView: UIViewRepresentable {
    
    /// Make UIVIew
    /// - Parameter context: The Context
    public func makeUIView(
        context: Context
    ) -> FlyoverKit.FlyoverMapView {
        .init(
            configuration: self.configuration,
            mapType: self.mapType
        )
    }
    
    /// Update UIView
    /// - Parameters:
    ///   - uiView: The UIView
    ///   - context: The Context
    public func updateUIView(
        _ uiView: FlyoverKit.FlyoverMapView,
        context: Context
    ) {
        // Set Configuration
        uiView.configuration = self.configuration
        // Set MapType
        uiView.flyoverMapType = self.mapType
        // Check if a Flyover is available
        if let flyover = self.flyover {
            // Start Flyover
            uiView.start(
                flyover: flyover
            )
        } else {
            // Stop Flyover
            uiView.stop()
        }
    }
    
}

#endif

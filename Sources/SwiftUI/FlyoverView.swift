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
    
    /// The `Flyover`
    public let flyover: FlyoverKit.Flyover?
    
    /// The `FlyoverCamera.Configuration`
    public let configuration: FlyoverKit.FlyoverCamera.Configuration
    
    /// The `FlyoverMapView.MapType`
    public let mapType: FlyoverKit.FlyoverMapView.MapType
    
    // MARK: Initializer
    
    /// Designated Initializer
    /// - Parameters:
    ///   - flyover: The optional `Flyover`
    ///   - configuration: The `FlyoverCamera.Configuration`. Default value `.default`
    ///   - mapType: The `FlyoverMapView.MapType`. Default value `.standard`
    public init(
        flyover: FlyoverKit.Flyover?,
        configuration: FlyoverKit.FlyoverCamera.Configuration = .default,
        mapType: FlyoverKit.FlyoverMapView.MapType = .standard
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
    
    /// Dismantle UIView
    /// - Parameters:
    ///   - uiView: The UIView
    ///   - coordinator: The Coordinator
    public static func dismantleUIView(
        _ uiView: FlyoverKit.FlyoverMapView,
        coordinator: Coordinator
    ) {
        // Stop Flyover
        uiView.stop()
    }
    
}

#endif

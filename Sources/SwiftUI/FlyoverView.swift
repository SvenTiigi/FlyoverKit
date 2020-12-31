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
    public let flyover: FlyoverKit.Flyover
    
    /// Bool value if flyover is started
    public let isStarted: Bool
    
    /// The `FlyoverCamera.Configuration`
    public let configuration: FlyoverKit.FlyoverCamera.Configuration
    
    /// The `FlyoverMapView.MapType`
    public let mapType: FlyoverKit.FlyoverMapView.MapType
    
    // MARK: Initializer
    
    /// Designated Initializer
    /// - Parameters:
    ///   - flyover: The `Flyover`
    ///   - isStarted: Bool value if flyover is started. Default value `true`
    ///   - configuration: The `FlyoverCamera.Configuration`. Default value `.default`
    ///   - mapType: The `FlyoverMapView.MapType`. Default value `.standard`
    public init(
        flyover: FlyoverKit.Flyover,
        isStarted: Bool = true,
        configuration: FlyoverKit.FlyoverCamera.Configuration = .default,
        mapType: FlyoverKit.FlyoverMapView.MapType = .standard
    ) {
        self.flyover = flyover
        self.isStarted = isStarted
        self.configuration = configuration
        self.mapType = mapType
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
        // Check if Configuration has changed
        if uiView.configuration != self.configuration {
            // Set new Configuration
            uiView.configuration = self.configuration
        }
        // Check if MapType has changed
        if uiView.flyoverMapType != self.mapType {
            // Set new MapType
            uiView.flyoverMapType = self.mapType
        }
        // Check if a flyover is started
        if self.isStarted {
            // Start Flyover
            uiView.start(
                flyover: self.flyover
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

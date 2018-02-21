//
//  FlyoverMapViewController.swift
//  FlyoverKit
//
//  Created by Sven Tiigi on 21.02.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import UIKit

// MARK: - FlyoverMapViewController

/// The FlyoverMapViewController
open class FlyoverMapViewController: UIViewController {
    
    // MARK: Properties
    
    /// The flyover MapView
    open var flyoverMapView: FlyoverMapView
    
    /// The flyover
    open var flyover: Flyover {
        didSet {
            // Start Flyover
            self.flyoverMapView.start(flyover: flyover)
        }
    }
    
    // MARK: Initializer
    
    /// Default initializer with flyover configuration and map type
    ///
    /// - Parameters:
    ///   - configuration: The flyover configuration
    ///   - mapType: The map type
    public init(flyover: Flyover,
                configuration: FlyoverCamera.Configuration = FlyoverCamera.Configuration.Theme.default.rawValue,
                mapType: FlyoverMapView.MapType = .standard) {
        self.flyoverMapView = FlyoverMapView(configuration: configuration, mapType: mapType)
        self.flyover = flyover
        super.init(nibName: nil, bundle: nil)
        self.flyoverMapView.start(flyover: flyover)
    }
    
    /// Convenience initializer with flyover configuration theme and map type
    ///
    /// - Parameters:
    ///   - configurationTheme: The flyover configuration theme
    ///   - mapType: The map type
    public convenience init(flyover: Flyover,
                            configurationTheme: FlyoverCamera.Configuration.Theme,
                            mapType: FlyoverMapView.MapType = .standard) {
        self.init(flyover: flyover, configuration: configurationTheme.rawValue, mapType: mapType)
    }
    
    /// Initializer with NSCoder. Returns nil
    required public init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    /// Deinit
    deinit {
        // Stop flyover
        self.flyoverMapView.stop()
    }
    
    // MARK: ViewLifecycle
    
    /// LoadView
    open override func loadView() {
        // Set FlyoverMapView as underlying view
        self.view = self.flyoverMapView
    }
    
}

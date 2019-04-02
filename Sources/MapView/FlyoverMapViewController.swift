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
    ///   - flyover: The flyover object
    ///   - configuration: The flyover configuration. Default value: `.default` theme
    ///   - mapType: The map type. Default value `.standard` type
    public init(flyover: Flyover,
                configuration: FlyoverCamera.Configuration = .default,
                mapType: FlyoverMapView.MapType = .standard) {
        self.flyoverMapView = FlyoverMapView(configuration: configuration, mapType: mapType)
        self.flyover = flyover
        super.init(nibName: nil, bundle: nil)
        self.flyoverMapView.start(flyover: flyover)
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
    
    // MARK: View-Lifecycle
    
    /// LoadView
    open override func loadView() {
        // Set FlyoverMapView as underlying view
        self.view = self.flyoverMapView
    }
    
}

//
//  FlyoverCamera.swift
//  FlyoverKit
//
//  Created by Sven Tiigi on 21.02.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import MapKit

// MARK: - FlyoverCamera

/// The FlyoverCamera
open class FlyoverCamera {
    
    // MARK: Public properties
    
    /// The configuration
    open var configuration: Configuration {
        willSet {
            // Force stop animation
            self.animator?.forceStopAnimation()
        }
        didSet {
            // Set MapCamera altitude
            self.mapCamera.altitude = self.configuration.altitude
            // Set MapCamera pitch
            self.mapCamera.pitch = CGFloat(self.configuration.pitch)
            // Restart flyover with current coordinate
            self.performFlyover(self.coordinate)
        }
    }
    
    /// Retrieve boolean if flyover has been started and is active
    open var isStarted: Bool {
        return self.coordinate != nil
    }
    
    // MARK: Private properties
    
    /// The MapView
    private weak var mapView: MKMapView?
    
    /// The MapView Camera
    private lazy var mapCamera: MKMapCamera = {
        let camera = MKMapCamera()
        camera.altitude = self.configuration.altitude
        camera.pitch = CGFloat(self.configuration.pitch)
        return camera
    }()
    
    /// The animation curve
    open let curve: UIViewAnimationCurve = .linear
    
    /// The current coordinate
    private var coordinate: CLLocationCoordinate2D?
    
    /// The UIViewPropertyAnimator
    private var animator: UIViewPropertyAnimator?
    
    // MARK: Initializer
    
    /// Default Initializer
    ///
    /// - Parameters:
    ///   - mapView: The MapView reference
    ///   - configuration: The Configuration
    public init(mapView: MKMapView, configuration: Configuration) {
        self.mapView = mapView
        self.configuration = configuration
    }
    
    /// Initialize with a predefined configuration theme
    ///
    /// - Parameters:
    ///   - mapView: The MapView
    ///   - configurationTheme: The configuration theme
    public convenience init(mapView: MKMapView, configurationTheme: Configuration.Theme = .default) {
        // Init with mapView and configurationTheme rawValue
        self.init(mapView: mapView, configuration: configurationTheme.rawValue)
    }
    
    /// Deinit
    deinit {
        /// Stop
        self.stop()
    }
    
    // MARK: Public API
    
    /// Start flyover with FlyoverAble object and optional region change animation mode
    ///
    /// - Parameters:
    ///   - flyover: The Flyover object (e.g. CLLocationCoordinate2D, CLLocation, MKMapPoint)
    open func start(flyover: Flyover) {
        // Set coordinate
        self.coordinate = flyover.coordinate
        // Stop current animation
        self.animator?.forceStopAnimation()
        // Set center coordinate
        self.mapCamera.centerCoordinate = flyover.coordinate
        // Check if duration is zero or the current mapView camera center coordinates
        // equals nearly the same to the current coordinate
        if self.mapView?.camera.centerCoordinate ~~ self.coordinate {
            // Simply perform flyover as we still looking at the same coordinate
            self.performFlyover(flyover.coordinate)
        } else if case .animated(let duration, let curve) = self.configuration.regionChangeAnimation, duration > 0 {
            // Apply StartAnimationMode animated
            // Initialize start animatior
            let startAnimator = UIViewPropertyAnimator(
                duration: duration,
                curve: curve,
                animations: {
                    // Set MapView Camera
                    self.mapView?.camera = self.mapCamera
            })
            // Add completion
            startAnimator.setCompletion {
                // Start rotation
                self.performFlyover(flyover.coordinate)
            }
            // Start animation
            startAnimator.startAnimation()
        } else {
            // No animation should be applied
            // Set MapView Camera to look at the coordinate
            self.mapView?.camera = self.mapCamera
            // Perform flyover
            self.performFlyover(flyover.coordinate)
        }
    }
    
    /// Stop flyover
    open func stop() {
        // Clear coordinate
        self.coordinate = nil
        // Unwrap MapView Camera Heading and fractionComplete
        guard var heading = self.mapView?.camera.heading,
            let fractionComplete = self.animator?.fractionComplete else {
                // Force stop animation
                self.animator?.forceStopAnimation()
                // Clear animator
                self.animator = nil
                // Return out function
                return
        }
        // Force stop animation
        self.animator?.forceStopAnimation()
        // Initialize Animator with stop animation
        self.animator = UIViewPropertyAnimator(
            duration: 0,
            curve: self.curve,
            animations: {
                // Substract the headingStep from current heading to retrieve start value
                heading -= self.configuration.headingStep
                // Initialize the percentage of the compeleted heading step
                let percentageCompletedHeadingStep = Double(fractionComplete) * self.configuration.headingStep
                // Set MapCamera Heading
                self.mapCamera.heading = fmod(heading + percentageCompletedHeadingStep, 360)
                // Set MapView Camera
                self.mapView?.camera = self.mapCamera
        })
        // Start animation
        self.animator?.startAnimation()
        // Clear animator as animation is been handeled
        self.animator = nil
    }
    
    // MARK: Private API
    
    /// Perform flyover at the given coordinate
    ///
    /// - Parameter coordinate: The coordinate
    private func performFlyover(_ coordinate: CLLocationCoordinate2D?) {
        // Unwrap coordinate
        guard let coordinate = coordinate else {
            // Coordinate unavailable return out of function
            return
        }
        // Increase heading by heading step for mapCamera
        self.mapCamera.heading = fmod(self.mapCamera.heading + self.configuration.headingStep, 360)
        // Initialize UIViewPropertyAnimator
        self.animator = UIViewPropertyAnimator(
            duration: self.configuration.duration,
            curve: self.curve,
            animations: {
                // Update MapViewCamera
                self.mapView?.camera = self.mapCamera
        })
        // Add completion
        self.animator?.setCompletion {
            // Check if coordinates are equal
            if self.coordinate ~~ coordinate {
                // Invoke recursion
                self.performFlyover(coordinate)
            }
        }
        // Start Animation
        self.animator?.startAnimation()
    }

}

// MARK: - UIViewPropertyAnimator Extension

fileprivate extension UIViewPropertyAnimator {
    
    /// Force Stop Animation
    func forceStopAnimation() {
        // Stop animation without finishing
        self.stopAnimation(true)
    }
    
    /// Convenience function to set the completion with no parameter closure
    ///
    /// - Parameter completion: The completion closure
    func setCompletion(_ completion: @escaping () -> Void) {
        // Add completion
        self.addCompletion { _ in
            // Invoke closure
            completion()
        }
    }
    
}

// MARK: - CLLocationCoordinate2D Comparison Extension

/// Nearly the same infix operator
infix operator ~~

fileprivate extension Optional where Wrapped == CLLocationCoordinate2D {
    
    /// Check if two given coordinates via infix operator are nearly the same
    /// via rounding the latitude and longitude to avoid float comparison
    ///
    /// - Parameters:
    ///   - lhs: The left hand side
    ///   - rhs: The right hand side
    /// - Returns: Boolean if the two coordinates are nearly the same
    static func ~~ (lhs: CLLocationCoordinate2D?, rhs: CLLocationCoordinate2D?) -> Bool {
        guard let lhs = lhs, let rhs = rhs else {
            return false
        }
        let factor = 1000.0
        return round(lhs.latitude * factor) == round(rhs.latitude * factor)
            && round(lhs.longitude * factor) == round(rhs.longitude * factor)
    }
    
}

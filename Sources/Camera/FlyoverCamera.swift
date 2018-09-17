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
            // Restart flyover with current flyover
            self.performFlyover(self.flyover)
        }
    }
    
    /// Retrieve FlyoverCamera State
    open var state: State
    
    /// The animation curve
    open var curve: UIView.AnimationCurve = .linear
    
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
    
    /// The flyover
    private var flyover: Flyover?
    
    /// The UIViewPropertyAnimator
    private var animator: UIViewPropertyAnimator?
    
    // MARK: Initializer
    
    /// Default Initializer
    ///
    /// - Parameters:
    ///   - mapView: The MapView
    ///   - configuration: The Configuration. Default value: `.default` theme
    public init(mapView: MKMapView, configuration: Configuration = .default) {
        // Set MapView
        self.mapView = mapView
        // Set Configuration
        self.configuration = configuration
        // Initialize state
        self.state = .stopped
        // Add application will resign active observer
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.applicationWillResignActive),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
        // Add application did become active observer
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.applicationDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    /// Deinit
    deinit {
        // Stop
        self.stop()
        // Remove observer
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Public API
    
    /// Start flyover with FlyoverAble object and optional region change animation mode
    ///
    /// - Parameters:
    ///   - flyover: The Flyover object (e.g. CLLocationCoordinate2D, CLLocation, MKMapPoint)
    open func start(flyover: Flyover) {
        // Set flyover
        self.flyover = flyover
        // Check if applicationState is not active
        if UIApplication.shared.applicationState != .active {
            // Return out of function
            return
        }
        // Change state
        self.state = .started
        // Stop current animation
        self.animator?.forceStopAnimation()
        // Set center coordinate
        self.mapCamera.centerCoordinate = flyover.coordinate
        // Check if duration is zero or the current mapView camera
        // equals nearly the same to the current flyover
        if self.mapView?.camera ~~ self.flyover {
            // Simply perform flyover as we still looking at the same coordinate
            self.performFlyover(flyover)
        } else if case .animated(let duration, let curve) = self.configuration.regionChangeAnimation, duration > 0 {
            // Apply StartAnimationMode animated
            // Initialize start animatior
            let startAnimator = UIViewPropertyAnimator(
                duration: duration,
                curve: curve,
                animations: { [weak self] in
                    // Verify self is available
                    guard let strongSelf = self else {
                        // Self isn't available return out of function
                        return
                    }
                    // Set MapView Camera
                    strongSelf.mapView?.camera = strongSelf.mapCamera
                }
            )
            // Add completion
            startAnimator.setCompletion { [weak self] in
                // Start rotation
                self?.performFlyover(flyover)
            }
            // Start animation
            startAnimator.startAnimation()
        } else {
            // No animation should be applied
            // Set MapView Camera to look at the coordinate
            self.mapView?.camera = self.mapCamera
            // Perform flyover
            self.performFlyover(flyover)
        }
    }
    
    /// Stop flyover
    open func stop() {
        // Change state
        self.state = .stopped
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
            animations: { [weak self] in
                // Verify self is available
                guard let strongSelf = self else {
                    // Self isn't available return out of function
                    return
                }
                // Substract the headingStep from current heading to retrieve start value
                heading -= strongSelf.configuration.headingStep
                // Initialize the percentage of the compeleted heading step
                let percentageCompletedHeadingStep = Double(fractionComplete) * strongSelf.configuration.headingStep
                // Set MapCamera Heading
                strongSelf.mapCamera.heading = fmod(heading + percentageCompletedHeadingStep, 360)
                // Set MapView Camera
                strongSelf.mapView?.camera = strongSelf.mapCamera
        })
        // Start animation
        self.animator?.startAnimation()
        // Clear animator as animation is been handeled
        self.animator = nil
    }
    
    // MARK: Private API
    
    /// Perform flyover at the given Flyover coordinate
    ///
    /// - Parameter flyover: The Flyover object
    private func performFlyover(_ flyover: Flyover?) {
        // Unwrap Flyover
        guard let flyover = flyover else {
            // Flyover unavailable return out of function
            return
        }
        // Increase heading by heading step for mapCamera
        self.mapCamera.heading = fmod(self.mapCamera.heading + self.configuration.headingStep, 360)
        // Initialize UIViewPropertyAnimator
        self.animator = UIViewPropertyAnimator(
            duration: self.configuration.duration,
            curve: self.curve,
            animations: { [weak self] in
                // Verify self is available
                guard let strongSelf = self else {
                    // Self isn't available return out of function
                    return
                }
                // Update MapViewCamera
                strongSelf.mapView?.camera = strongSelf.mapCamera
        })
        // Add completion
        self.animator?.setCompletion { [weak self] in
            // Check if flyovers are nearly equal
            if self?.flyover ~~ flyover {
                // Invoke recursion
                self?.performFlyover(flyover)
            }
        }
        // Start Animation
        self.animator?.startAnimation()
    }

    /// UIApplicationWillResignActive notification handler
    @objc private func applicationWillResignActive() {
        // Check if current state is not stopped
        if self.state != .stopped {
            // Stop flyover as application is no longer active
            self.stop()
        } else {
            // Clear Flyover to prevent start on didBecomeActive
            self.flyover = nil
        }
    }
    
    /// UIApplicationDidBecomeActive notification handler
    @objc private func applicationDidBecomeActive() {
        // Start if flyover is available
        self.flyover.flatMap(self.start)
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

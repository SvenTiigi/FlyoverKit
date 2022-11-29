import MapKit

// MARK: - Flyover

/// A Flyover
public final class Flyover {
    
    // MARK: Properties
    
    /// The property animator
    private let animator = Animator()
    
    /// Bool value whether Flyover is currently started or stopped
    public private(set) var isStarted = false
    
    /// The map view
    public weak var mapView: MKMapView?
    
    /// The Context
    private var context: Context?
    
    // MARK: Initializer
    
    /// Creates a new instance of `Flyover`
    /// - Parameters:
    ///   - mapView: The MKMapView (weakly referenced)
    public init(
        mapView: MKMapView
    ) {
        self.mapView = mapView
    }
    
}

// MARK: - Start

public extension Flyover {
    
    /// Start Flyover
    /// - Parameters:
    ///   - coordinate: The Coordinate
    ///   - configuration: The Flyover Configuration. Default value `.default`
    @discardableResult
    func start(
        at coordinate: CLLocationCoordinate2D,
        configuration: Configuration = .default
    ) -> Bool {
        // Verify the map view is available and the given coordinate is valid
        guard let mapView = self.mapView, CLLocationCoordinate2DIsValid(coordinate) else {
            // Stop
            self.stop()
            // Otherwise return false as Flyover could not be started
            return false
        }
        // Check if coordinate has changed
        if self.context?.matches(with: coordinate) == false {
            // Change camera to new coordinate without animation
            mapView.camera = .init(
                lookingAtCenter: coordinate,
                fromDistance: mapView.camera.centerCoordinateDistance,
                pitch: mapView.camera.pitch,
                heading: mapView.camera.heading
            )
        }
        // Set Context
        self.context = .init(
            coordinate: coordinate,
            configuration: configuration
        )
        // Verify is not started
        guard !self.isStarted else {
            // Otherwise return out of function
            return self.isStarted
        }
        // Start animation
        let isStarted = self.startAnimation()
        // Update is started state
        self.isStarted = isStarted
        // Return is started
        return isStarted
    }
    
}

// MARK: - Start Animation

private extension Flyover {
    
    /// Start Animation
    @discardableResult
    func startAnimation() -> Bool {
        // Verify map view and context are available
        guard let mapView = self.mapView,
              let context = self.context else {
            // Otherwise return false as animation could not be started
            return false
        }
        // Start animation
        self.animator.start(
            duration: context.configuration.animationDuration,
            curve: context.configuration.animationCurve,
            animations: { [weak mapView] in
                // Verify map view is available
                guard let mapView = mapView else {
                    // Otherwise return out of function
                    return
                }
                // Update heading
                mapView.camera = .init(
                    lookingAtCenter: context.coordinate,
                    fromDistance: context.configuration.altitude(mapView.camera.centerCoordinateDistance),
                    pitch: context.configuration.pitch(mapView.camera.pitch),
                    heading: fmod(
                        context.configuration.heading(mapView.camera.heading),
                        360
                    )
                )
            },
            completion: { [weak self] in
                // Restart animation
                self?.startAnimation()
            }
        )
        // Return true as animation was started succesfully
        return true
    }
    
}

// MARK: - Resume

public extension Flyover {
    
    /// Resume Flyover with the latest coordiante and configuration, if available
    /// - Returns: A Bool value if the Flyover could be resumed
    @discardableResult
    func resume() -> Bool {
        // Verify flyover is not started
        guard !self.isStarted else {
            // Otherwise return false as Flyover can not be resumed
            return false
        }
        // Restart animation
        return self.startAnimation()
    }
    
}

// MARK: - Stop

public extension Flyover {
    
    /// Stop Flyover
    func stop() {
        // Disable is started
        self.isStarted = false
        // Verify MapView and PropertyAnimator are available
        guard let fractionComplete = self.animator.stop(),
              let mapView = self.mapView,
              let context = self.context else {
            // Return out of function
            return
        }
        // Switch on map type
        switch mapView.mapType {
        case .standard, .mutedStandard:
            // Set heading
            mapView.camera.heading = fmod(
                {
                    let heading = mapView.camera.heading
                    let headingDelta = (context.configuration.heading(heading) - heading)
                    return (heading - headingDelta) + (fractionComplete * headingDelta)
                }(),
                360
            )
        default:
            // Re-apply the heading to stop any ongoing animations
            mapView.camera.heading = mapView.camera.heading
        }
    }
    
}

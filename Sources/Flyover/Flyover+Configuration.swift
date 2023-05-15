import CoreLocation
import UIKit

// MARK: - Flyover+Configuration

public extension Flyover {
    
    /// A Flyover Configuration
    struct Configuration {
        
        // MARK: Properties

        /// Camera change animation when changing coordinates
        public var animateLocationChanges: Bool

        /// The animation duration in seconds
        public var animationDuration: TimeInterval
        
        /// The animation curve
        public var animationCurve: UIView.AnimationCurve
        
        /// The altitude above the ground, measured in meters
        public var altitude: Parameter<CLLocationDistance>
        
        /// The viewing angle of the camera, measured in degrees
        public var pitch: Parameter<Double>
        
        /// The heading of the camera (measured in degrees) relative to true north
        public var heading: Parameter<CLLocationDirection>
        
        // MARK: Initializer
        
        /// Creates a new instance of `Flyover.Configuration`
        /// - Parameters:
        ///   - animateLocationChanges: The camera change animation. Default value `false`
        ///   - animationDuration: The animation duration in seconds. Default value `1`
        ///   - animationCurve: The animation curve. Default value `.linear`
        ///   - altitude: The altitude above the ground, measured in meters
        ///   - pitch: The viewing angle of the Flyover, measured in degrees
        ///   - heading: The heading of the Flyover, measured in degrees, relative to true north
        public init(
            animateLocationChanges: Bool = false,
            animationDuration: TimeInterval = 1,
            animationCurve: UIView.AnimationCurve = .linear,
            altitude: Parameter<CLLocationDistance>,
            pitch: Parameter<Double>,
            heading: Parameter<CLLocationDirection>
        ) {
            self.animateLocationChanges = animateLocationChanges
            self.animationDuration = animationDuration
            self.animationCurve = animationCurve
            self.altitude = altitude
            self.pitch = pitch
            self.heading = heading
        }
    }
    
}

// MARK: - Flyover+Configuration+default

public extension Flyover.Configuration {
    
    /// A default Flyover Configuration
    static let `default` = Self(
        altitude: 2000,
        pitch: 50,
        heading: .increment(by: 1.5)
    )
    
}

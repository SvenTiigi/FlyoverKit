import CoreLocation
import UIKit

// MARK: - Flyover+Configuration

public extension Flyover {
    
    /// A Flyover Configuration
    struct Configuration {
        
        // MARK: Properties
        
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
        ///   - animationDuration: The animation duration in seconds. Default value `1`
        ///   - animationCurve: The animation curve. Default value `.linear`
        ///   - altitude: The altitude above the ground, measured in meters
        ///   - pitch: The viewing angle of the Flyover, measured in degrees
        ///   - heading: The heading of the Flyover, measured in degrees, relative to true north
        public init(
            animationDuration: TimeInterval = 1,
            animationCurve: UIView.AnimationCurve = .linear,
            altitude: Parameter<CLLocationDistance>,
            pitch: Parameter<Double>,
            heading: Parameter<CLLocationDirection>
        ) {
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

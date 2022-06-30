import CoreLocation
import Foundation

// MARK: - Flyover+Context

extension Flyover {
    
    /// A Flyover Context
    struct Context {
        
        /// The CLLocationCoordinate2D
        let coordinate: CLLocationCoordinate2D
        
        /// The Configuration
        let configuration: Configuration
        
    }
    
}

// MARK: - Flyover+Context+matches(with:)

extension Flyover.Context {
    
    /// Retrieve a Bool value whether a given Coordinate matches with the current one
    /// - Parameter coordinate: The Coordinate to check
    func matches(
        with coordinate: CLLocationCoordinate2D
    ) -> Bool {
        self.coordinate.latitude == coordinate.latitude
            && self.coordinate.longitude == coordinate.longitude
    }
    
}

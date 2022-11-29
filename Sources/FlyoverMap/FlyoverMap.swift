import MapKit
import SwiftUI

// MARK: - FlyoverMap

/// A FlyoverMap
public struct FlyoverMap {
    
    // MARK: Properties
    
    /// Bool value if Flyover is started
    private let isStarted: Bool
    
    /// The Coordinate
    private let coordinate: CLLocationCoordinate2D

    /// The Flyover Configuration
    private let configuration: Flyover.Configuration
    
    /// The MapType
    private let mapType: MKMapType
    
    /// A closure to update the underlying FlyoverMapView
    private let updateMapView: ((FlyoverMapView) -> Void)?
    
    // MARK: Initializer
    
    /// Creates a new instance of `FlyoverMap`
    /// - Parameters:
    ///   - isStarted: Bool value if Flyover is started. Default value `true`
    ///   - coordinate: The Coordinate
    ///   - configuration: The Flyover Configuration. Default value `.default`
    ///   - mapView: The MapType. Default value `.standard`
    ///   - updateMapView: A closure to update the underlying FlyoverMapView. Default value `nil`
    public init(
        isStarted: Bool = true,
        coordinate: CLLocationCoordinate2D,
        configuration: Flyover.Configuration = .default,
        mapType: MKMapType = .standard,
        updateMapView: ((FlyoverMapView) -> Void)? = nil
    ) {
        self.isStarted = isStarted
        self.coordinate = coordinate
        self.configuration = configuration
        self.mapType = mapType
        self.updateMapView = updateMapView
    }
    
}

// MARK: - Convenience Initializer

public extension FlyoverMap {
    
    /// Creates a new instance of `FlyoverMap`
    /// - Parameters:
    ///   - isStarted: Bool value if Flyover is started. Default value `true`
    ///   - latitude: The latitude.
    ///   - longitude: The longitude.
    ///   - configuration: The Flyover Configuration. Default value `.default`
    ///   - mapView: The MapType. Default value `.standard`
    ///   - updateMapView: A closure to update the underlying FlyoverMapView. Default value `nil`
    init(
        isStarted: Bool = true,
        latitude: CLLocationDegrees,
        longitude: CLLocationDegrees,
        configuration: Flyover.Configuration = .default,
        mapType: MKMapType = .standard,
        updateMapView: ((FlyoverMapView) -> Void)? = nil
    ) {
        self.init(
            isStarted: isStarted,
            coordinate: .init(
                latitude: latitude,
                longitude: longitude
            ),
            configuration: configuration,
            mapType: mapType,
            updateMapView: updateMapView
        )
    }
    
}

// MARK: - UIViewRepresentable

extension FlyoverMap: UIViewRepresentable {
    
    /// Make MKMapView
    /// - Parameter context: The Context
    public func makeUIView(
        context: Context
    ) -> FlyoverMapView {
        .init()
    }
    
    /// Update MKMapView
    /// - Parameters:
    ///   - flyoverMapView: The FlyoverMapView
    ///   - context: The Context
    public func updateUIView(
        _ flyoverMapView: FlyoverMapView,
        context: Context
    ) {
        // Update map type
        flyoverMapView.mapType = self.mapType
        // Update map view if needed
        self.updateMapView?(flyoverMapView)
        // Check if is started
        if self.isStarted {
            // Start Flyover
            flyoverMapView.startFlyover(
                at: self.coordinate,
                configuration: self.configuration
            )
        } else {
            // Stop Flyover
            flyoverMapView.stopFlyover()
        }
    }
    
}

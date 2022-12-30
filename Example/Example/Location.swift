import CoreLocation

// MARK: - Location

/// A Location
struct Location {
    
    /// The name
    let name: String
    
    /// The coordinate
    let coordinate: CLLocationCoordinate2D
    
}

// MARK: - Equatable

extension Location: Equatable {
    
    /// Returns a Boolean value indicating whether two values are equal
    /// - Parameters:
    ///   - lhs: A value to compare
    ///   - rhs: Another value to compare
    static func == (
        lhs: Self,
        rhs: Self
    ) -> Bool {
        lhs.name == rhs.name
            && lhs.coordinate.latitude == rhs.coordinate.latitude
            && lhs.coordinate.longitude == rhs.coordinate.longitude
    }
    
}

// MARK: - Hashable

extension Location: Hashable {
    
    /// Hashes the essential components of this value by feeding them into the given hasher
    /// - Parameter hasher: The hasher to use when combining the components of this instance
    func hash(
        into hasher: inout Hasher
    ) {
        hasher.combine(self.name)
        hasher.combine(self.coordinate.latitude)
        hasher.combine(self.coordinate.longitude)
    }
    
}

// MARK: - Apple Park

extension Location {
    
    /// Apple Park Location
    static let applePark = Self(
        name: "Apple Park",
        coordinate: .init(
            latitude: 37.3348,
            longitude: -122.0090
        )
    )
    
}

// MARK: - All

extension Location {
    
    /// All locations
    static let all: [Self] = [
        .applePark,
        .init(
            name: "Infinite Loop",
            coordinate: .init(
                latitude: 37.3317,
                longitude: -122.0302
            )
        ),
        .init(
            name: "Coit Tower",
            coordinate: .init(
                latitude: 37.8024,
                longitude: -122.4058
            )
        ),
        .init(
            name: "Fisherman's Wharf",
            coordinate: .init(
                latitude: 37.8099,
                longitude: -122.4103
            )
        ),
        .init(
            name: "Ferry Building",
            coordinate: .init(
                latitude: 37.7956,
                longitude: -122.3935
            )
        ),
        .init(
            name: "Oracle Park",
            coordinate: .init(
                latitude: 37.7786,
                longitude: -122.3893
            )
        ),
        .init(
            name: "Big Ben",
            coordinate: .init(
                latitude: 51.4994,
                longitude: -0.1245
            )
        )
    ]
    
}

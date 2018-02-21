//
//  FlyoverAble.swift
//  FlyoverKit
//
//  Created by Sven Tiigi on 21.02.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import MapKit

// MARK: - FlyoverAble Protocol

public protocol FlyoverAble {
    /// The coordinate
    var coordinate: CLLocationCoordinate2D { get }
}

// MARK: - CoreLocation Framework FlyoverAble Extension

extension CLLocationCoordinate2D: FlyoverAble {
    /// The coordinate
    public var coordinate: CLLocationCoordinate2D {
        return self
    }
}
extension CLCircularRegion: FlyoverAble {
    /// The coordinate
    public var coordinate: CLLocationCoordinate2D {
        return self.center
    }
}
extension CLLocation: FlyoverAble { }
extension CLVisit: FlyoverAble { }

// MARK: - MapKit Framework FlyoverAble Extension

extension MKMapPoint: FlyoverAble {
    /// The coordinate
    public var coordinate: CLLocationCoordinate2D {
        return MKCoordinateForMapPoint(self)
    }
}
extension MKCoordinateRegion: FlyoverAble {
    /// The coordinate
    public var coordinate: CLLocationCoordinate2D {
        return self.center
    }
}
extension MKMapRect: FlyoverAble {
    /// The coordinate
    public var coordinate: CLLocationCoordinate2D {
        return self.origin.coordinate
    }
}
extension MKCoordinateSpan: FlyoverAble {
    /// The coordinate
    public var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitudeDelta, longitude: self.longitudeDelta)
    }
}
extension MKShape: FlyoverAble { }
extension MKPlacemark: FlyoverAble { }

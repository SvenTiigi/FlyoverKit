//
//  FlyoverProtocolTests.swift
//  FlyoverKitTests
//
//  Created by Sven Tiigi on 24.02.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import XCTest
@testable import FlyoverKit
import CoreLocation
import MapKit

class FlyoverProtocolTests: BaseTests {
    
    func testFlyoverCLLocationCoordinate2D() {
        let coordinate = self.randomCoordinate
        XCTAssertFlyover(coordinate, coordinate.coordinate)
    }
    
    func testFlyoverCLCircularRegion() {
        let coordinate = self.randomCoordinate
        let region = CLCircularRegion(center: coordinate, radius: 300, identifier: "")
        XCTAssertFlyover(coordinate, region)
    }
    
    func testFlyoverMKMapItem() {
        let coordinate = self.randomCoordinate
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        XCTAssertFlyover(coordinate, mapItem)
    }
    
    func testFlyoverMKMapPoint() {
        let mockValue = (x: self.randomDouble, y: self.randomDouble)
        let mapPoint = MKMapPoint(x: mockValue.x, y: mockValue.y)
        let coordinate = MKCoordinateForMapPoint(mapPoint)
        XCTAssertFlyover(mapPoint, coordinate)
    }
    
    func testFlyoverMKCoorindateRegionAndSpan() {
        let coordinate = self.randomCoordinate
        let span = MKCoordinateSpan(latitudeDelta: coordinate.latitude, longitudeDelta: coordinate.longitude)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        XCTAssertFlyover(coordinate, region)
        XCTAssertFlyover(coordinate, span)
    }
    
    func testFlyoverMapView() {
        let mapView = MKMapView()
        let coordinate = mapView.centerCoordinate
        XCTAssertFlyover(coordinate, mapView)
    }
    
    func testFlyoverMKMapRect() {
        let mockValue = (x: self.randomDouble, y: self.randomDouble)
        let mapPoint = MKMapPoint(x: mockValue.x, y: mockValue.y)
        let coordinate = MKCoordinateForMapPoint(mapPoint)
        let rect = MKMapRect(origin: mapPoint, size: MKMapSize(width: mockValue.x, height: mockValue.y))
        XCTAssertFlyover(coordinate, rect)
    }
    
    func testFlyoverAwesomePlaceCases() {
        for place in FlyoverAwesomePlace.iterate() {
            XCTAssertFlyover(place, place.coordinate)
        }
    }
    
}

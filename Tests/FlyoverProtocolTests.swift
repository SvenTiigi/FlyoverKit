//
//  FlyoverProtocolTests.swift
//  FlyoverKitTests
//
//  Created by Sven Tiigi on 24.02.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import CoreLocation
@testable import FlyoverKit
import MapKit
import XCTest

class FlyoverProtocolTests: BaseTests {
    
    func testFlyoverOperator() {
        let flyover1: Flyover = self.randomCoordinate
        let flyover2: Flyover? = flyover1
        let flyover3: Flyover = self.randomCoordinate
        let flyover4: Flyover? = nil
        let flyover5: Flyover? = flyover3
        XCTAssertTrue(flyover1 == flyover2)
        XCTAssertTrue(flyover1 ~~ flyover2)
        XCTAssertFalse(flyover1 == flyover4)
        XCTAssertFalse(flyover2 ~~ flyover4)
        XCTAssertFalse(flyover1 == flyover3)
        XCTAssertFalse(flyover2 ~~ flyover3)
        XCTAssertFalse(flyover3 == flyover4)
        XCTAssertFalse(flyover3 ~~ flyover4)
        XCTAssertTrue(flyover3 == flyover5)
        XCTAssertTrue(flyover3 ~~ flyover5)
    }
    
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
        let coordinate = mapPoint.coordinate
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
        let coordinate = mapPoint.coordinate
        let rect = MKMapRect(origin: mapPoint, size: MKMapSize(width: mockValue.x, height: mockValue.y))
        XCTAssertFlyover(coordinate, rect)
    }
    
    func testFlyoverMKMapCamera() {
        let coordinate = self.randomCoordinate
        let camera = MKMapCamera()
        camera.centerCoordinate = coordinate
        XCTAssertFlyover(coordinate, camera)
    }
    
    func testFlyoverAwesomePlaceCases() {
        for place in FlyoverAwesomePlace.iterate() {
            XCTAssertFlyover(place, place.coordinate)
        }
    }
    
}

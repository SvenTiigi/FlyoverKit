//
//  FlyoverKitTests.swift
//  FlyoverKitTests
//
//  Created by Sven Tiigi on 21.02.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import XCTest
import MapKit
@testable import FlyoverKit

class FlyoverKitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        self.continueAfterFailure = false
    }
    
    /// Perform test with expectation
    ///
    /// - Parameters:
    ///   - name: The expectation name
    ///   - execution: The test execution
    public func performTest(_ expectationName: String, _ execution: (XCTestExpectation) -> Void) {
        // Create expectation with function name
        let expectation = self.expectation(description: expectationName)
        // Perform test execution with expectation
        execution(expectation)
        // Wait for expectation been fulfilled with default timeout
        self.waitForExpectations(timeout: 15, handler: nil)
    }
    
    func testConfigurationEquatable() {
        let duration = 1.0
        let altitude = 2.0
        let pitch = 3.0
        let headingStep = 4.0
        let configuration1 = FlyoverCamera.Configuration(
            duration: duration,
            altitude: altitude,
            pitch: pitch,
            headingStep: headingStep
        )
        let configuration2 = FlyoverCamera.Configuration(
            duration: duration,
            altitude: altitude,
            pitch: pitch,
            headingStep: headingStep
        )
        XCTAssertEqual(duration, configuration1.duration)
        XCTAssertEqual(altitude, configuration1.altitude)
        XCTAssertEqual(pitch, configuration1.pitch)
        XCTAssertEqual(headingStep, configuration1.headingStep)
        XCTAssertEqual(configuration1, configuration2)
    }
    
    func testFlyoverCameraDefaultInitializerConfiguration() {
        let mapView = MKMapView()
        let flyoverCamera = FlyoverCamera(mapView: mapView)
        XCTAssertEqual(flyoverCamera.configuration, FlyoverCamera.Configuration.Theme.default.rawValue)
    }
    
    func testFlyoverConfigurationThemeInitializer() {
        let configuration = FlyoverCamera.Configuration(
            duration: 1.0,
            altitude: 2.0,
            pitch: 3.0,
            headingStep: 4.0
        )
        XCTAssertNil(FlyoverCamera.Configuration.Theme(rawValue: configuration))
    }
    
    func testFlyoverCameraConfigurationTheme() {
        let mapView = MKMapView()
        let configurationThemes: [FlyoverCamera.Configuration.Theme] = [
            .default,
            .lowFlying,
            .farAway,
            .giddy
        ]
        configurationThemes.forEach { (theme) in
            let flyoverCamera = FlyoverCamera(mapView: mapView, configurationTheme: theme)
            XCTAssertEqual(flyoverCamera.configuration, theme.rawValue)
        }
    }
    
    func testFlyoverCameraStartStop() {
        let mapView = MKMapView()
        let flyoverCamera = FlyoverCamera(mapView: mapView)
        XCTAssertFalse(flyoverCamera.isStarted)
        flyoverCamera.start(flyover: FlyoverAwesomePlace.parisEiffelTower)
        XCTAssertTrue(flyoverCamera.isStarted)
        flyoverCamera.stop()
        XCTAssertFalse(flyoverCamera.isStarted)
        flyoverCamera.configuration.regionChangeAnimation = .animated(duration: 0.1, curve: .linear)
        flyoverCamera.configuration.duration = 0.1
        flyoverCamera.start(flyover: FlyoverAwesomePlace.appleHeadquarter)
        self.performTest(#function) { (expectation) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                XCTAssertTrue(flyoverCamera.isStarted)
                flyoverCamera.start(flyover: FlyoverAwesomePlace.googlePlex)
                XCTAssertTrue(flyoverCamera.isStarted)
                flyoverCamera.stop()
                XCTAssertFalse(flyoverCamera.isStarted)
                expectation.fulfill()
            })
        }
    }
    
    func testFlyoverMapViewDefaultInitializer() {
        let mapView = FlyoverMapView()
        XCTAssertEqual(mapView.configuration, FlyoverCamera.Configuration.Theme.default.rawValue)
        XCTAssertEqual(mapView.flyoverMapType, .standard)
    }
    
    func testFlyoverMapViewConvenienceInitializer() {
        let theme = FlyoverCamera.Configuration.Theme.farAway
        let mapType: FlyoverMapView.MapType = .satelliteFlyover
        let mapView = FlyoverMapView(configurationTheme: theme, mapType: mapType)
        XCTAssertEqual(mapView.configuration, theme.rawValue)
        XCTAssertEqual(mapView.flyoverMapType, mapType)
    }
    
    func testFlyoverMapViewStartStop() {
        let mapView = FlyoverMapView()
        XCTAssertFalse(mapView.isStarted)
        mapView.start(flyover: FlyoverAwesomePlace.appleHeadquarter)
        XCTAssertTrue(mapView.isStarted)
        mapView.stop()
        XCTAssertFalse(mapView.isStarted)
        let annotation = MKPointAnnotation()
        let mockValue = 2.0
        annotation.coordinate = CLLocationCoordinate2D(latitude: mockValue, longitude: mockValue)
        mapView.start(annotation: annotation)
        XCTAssertTrue(mapView.isStarted)
        mapView.stop()
        XCTAssertFalse(mapView.isStarted)
    }
    
    func testFlyoverMapViewMapType() {
        let standard: FlyoverMapView.MapType = .standard
        let satelliteFlyover: FlyoverMapView.MapType = .satelliteFlyover
        let hybridFlyover: FlyoverMapView.MapType = .hybridFlyover
        XCTAssertEqual(MKMapType.standard, standard.rawValue)
        XCTAssertEqual(MKMapType.satelliteFlyover, satelliteFlyover.rawValue)
        XCTAssertEqual(MKMapType.hybridFlyover, hybridFlyover.rawValue)
        XCTAssertEqual([MKMapType.standard, MKMapType.satelliteFlyover, MKMapType.hybridFlyover].map(FlyoverMapView.MapType.init).count, 3)
        XCTAssertNil(FlyoverMapView.MapType.init(rawValue: .satellite))
        let mapView = FlyoverMapView()
        mapView.flyoverMapType = satelliteFlyover
        XCTAssertNotNil(mapView.flyoverMapType)
        XCTAssertEqual(mapView.flyoverMapType, satelliteFlyover)
        XCTAssertEqual(mapView.mapType, .satelliteFlyover)
        mapView.mapType = .satellite
        XCTAssertNil(mapView.flyoverMapType)
    }
    
    func testFlyoverMapViewController() {
        var flyover = FlyoverAwesomePlace.appleHeadquarter
        let controller = FlyoverMapViewController(flyover: flyover)
        XCTAssertEqual(controller.flyover.coordinate.latitude, flyover.coordinate.latitude)
        XCTAssertEqual(controller.flyover.coordinate.longitude, flyover.coordinate.longitude)
        XCTAssertTrue(controller.flyoverMapView.isStarted)
        XCTAssertEqual(controller.flyoverMapView.configuration, FlyoverCamera.Configuration.Theme.default.rawValue)
        XCTAssertEqual(controller.flyoverMapView.flyoverMapType, .standard)
        flyover = FlyoverAwesomePlace.googlePlex
        controller.flyover = flyover
        XCTAssertEqual(controller.flyover.coordinate.latitude, flyover.coordinate.latitude)
        XCTAssertEqual(controller.flyover.coordinate.longitude, flyover.coordinate.longitude)
        XCTAssertTrue(controller.flyoverMapView.isStarted)
    }
    
    func testFlyoverCLLocationCoordinate2D() {
        let mockValue = 2.0
        let coordinate = CLLocationCoordinate2D(latitude: mockValue, longitude: mockValue)
        XCTAssertEqual(mockValue, coordinate.coordinate.latitude)
        XCTAssertEqual(mockValue, coordinate.coordinate.longitude)
    }
    
    func testFlyoverCLCircularRegion() {
        let mockValue = 2.0
        let coordinate = CLLocationCoordinate2D(latitude: mockValue, longitude: mockValue)
        let region = CLCircularRegion(center: coordinate, radius: 300, identifier: "")
        XCTAssertEqual(region.coordinate.latitude, mockValue)
        XCTAssertEqual(region.coordinate.longitude, mockValue)
    }
    
    func testFlyoverMKMapItem() {
        let mockValue = 2.0
        let coordinate = CLLocationCoordinate2D(latitude: mockValue, longitude: mockValue)
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        XCTAssertEqual(mapItem.coordinate.latitude, mockValue)
        XCTAssertEqual(mapItem.coordinate.longitude, mockValue)
    }
    
    func testFlyoverMKMapPoint() {
        let mockValue = 2.0
        let mapPoint = MKMapPoint(x: mockValue, y: mockValue)
        let coordinate = MKCoordinateForMapPoint(mapPoint)
        XCTAssertEqual(mapPoint.coordinate.latitude, coordinate.latitude)
        XCTAssertEqual(mapPoint.coordinate.longitude, coordinate.longitude)
    }
    
    func testFlyoverMKCoorindateRegionAndSpan() {
        let mockValue = 2.0
        let coordinate = CLLocationCoordinate2D(latitude: mockValue, longitude: mockValue)
        let span = MKCoordinateSpan(latitudeDelta: mockValue, longitudeDelta: mockValue)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        XCTAssertEqual(region.coordinate.latitude, mockValue)
        XCTAssertEqual(region.coordinate.longitude, mockValue)
        XCTAssertEqual(span.coordinate.latitude, mockValue)
        XCTAssertEqual(span.coordinate.longitude, mockValue)
    }
    
    func testFlyoverMKMapRect() {
        let mockValue = 2.0
        let mapPoint = MKMapPoint(x: mockValue, y: mockValue)
        let coordinate = MKCoordinateForMapPoint(mapPoint)
        let rect = MKMapRect(origin: mapPoint, size: MKMapSize(width: mockValue, height: mockValue))
        XCTAssertEqual(rect.coordinate.latitude, coordinate.latitude)
        XCTAssertEqual(rect.coordinate.longitude, coordinate.longitude)
    }
    
}

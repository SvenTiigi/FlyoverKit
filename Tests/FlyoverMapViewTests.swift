//
//  FlyoverMapViewTests.swift
//  FlyoverKitTests
//
//  Created by Sven Tiigi on 24.02.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

@testable import FlyoverKit
import MapKit
import XCTest

class FlyoverMapViewTests: BaseTests {
    
    // MARK: FlyoverMapView
    
    func testFlyoverMapViewDefaultInitializer() {
        let mapView = FlyoverMapView()
        XCTAssertEqual(mapView.configuration, .default)
        XCTAssertEqual(mapView.flyoverMapType, .standard)
    }
    
    func testFlyoverMapViewConvenienceInitializer() {
        let theme: FlyoverCamera.Configuration = .farAway
        let mapType: FlyoverMapView.MapType = .satelliteFlyover
        let mapView = FlyoverMapView(configuration: theme, mapType: mapType)
        XCTAssertEqual(mapView.configuration, theme)
        XCTAssertEqual(mapView.flyoverMapType, mapType)
    }
    
    func testFlyoverMapViewStartStop() {
        let mapView = FlyoverMapView()
        XCTAssertFalse(mapView.state == .started)
        mapView.start(flyover: FlyoverAwesomePlace.appleHeadquarter)
        XCTAssertTrue(mapView.state == .started)
        mapView.stop()
        XCTAssertFalse(mapView.state == .started)
        let annotation = MKPointAnnotation()
        annotation.coordinate = self.randomCoordinate
        mapView.start(annotation: annotation)
        XCTAssertTrue(mapView.state == .started)
        mapView.stop()
        XCTAssertFalse(mapView.state == .started)
    }
    
    func testFlyoverMapViewMapType() {
        let standard: FlyoverMapView.MapType = .standard
        let satelliteFlyover: FlyoverMapView.MapType = .satelliteFlyover
        let hybridFlyover: FlyoverMapView.MapType = .hybridFlyover
        XCTAssertEqual(MKMapType.standard, standard.rawValue)
        XCTAssertEqual(MKMapType.satelliteFlyover, satelliteFlyover.rawValue)
        XCTAssertEqual(MKMapType.hybridFlyover, hybridFlyover.rawValue)
        XCTAssertEqual([
            MKMapType.standard,
            MKMapType.satelliteFlyover,
            MKMapType.hybridFlyover
            ].map(FlyoverMapView.MapType.init).count, 3)
        XCTAssertNil(FlyoverMapView.MapType.init(rawValue: .satellite))
        let mapView = FlyoverMapView()
        mapView.flyoverMapType = satelliteFlyover
        XCTAssertNotNil(mapView.flyoverMapType)
        XCTAssertEqual(mapView.flyoverMapType, satelliteFlyover)
        XCTAssertEqual(mapView.mapType, .satelliteFlyover)
        mapView.mapType = .satellite
        XCTAssertNil(mapView.flyoverMapType)
    }
    
    func testFlyoverMapViewConfigurationUpdate() {
        let flyoverMapView = FlyoverMapView()
        let configuration: FlyoverCamera.Configuration  = .farAway
        flyoverMapView.configuration = configuration
        XCTAssertEqual(configuration, flyoverMapView.configuration)
    }
    
    func testFlyoverMapViewUnsupportedInitializer() {
        XCTAssertNil(FlyoverMapView(coder: NSCoder()))
    }
    
    // MARK: FlyoverMapViewController
    
    func testFlyoverMapViewController() {
        var flyover = FlyoverAwesomePlace.appleHeadquarter
        let controller = FlyoverMapViewController(flyover: flyover)
        XCTAssertFlyover(flyover, controller.flyover)
        XCTAssertEqual(controller.view, controller.flyoverMapView)
        XCTAssertTrue(controller.flyoverMapView.state == .started)
        XCTAssertEqual(controller.flyoverMapView.configuration, .default)
        XCTAssertEqual(controller.flyoverMapView.flyoverMapType, .standard)
        flyover = FlyoverAwesomePlace.googlePlex
        controller.flyover = flyover
        XCTAssertFlyover(flyover, controller.flyover)
        XCTAssertTrue(controller.flyoverMapView.state == .started)
    }
    
    func testFlyoverMapViewControllerThemeInitializer() {
        let flyover = FlyoverAwesomePlace.googlePlex
        let controller = FlyoverMapViewController(
            flyover: flyover,
            configuration: .farAway, mapType: .satelliteFlyover
        )
        XCTAssertFlyover(flyover, controller.flyover)
        XCTAssertEqual(controller.flyoverMapView.configuration, .farAway)
        XCTAssertEqual(controller.flyoverMapView.flyoverMapType, .satelliteFlyover)
    }
    
    func testFlyoverMapViewControllerUnsupportedInitializer() {
        XCTAssertNil(FlyoverMapViewController(coder: NSCoder()))
    }
    
}

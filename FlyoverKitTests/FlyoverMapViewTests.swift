//
//  FlyoverMapViewTests.swift
//  FlyoverKitTests
//
//  Created by Sven Tiigi on 24.02.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import XCTest
@testable import FlyoverKit
import MapKit

class FlyoverMapViewTests: BaseTests {
    
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
        annotation.coordinate = self.randomCoordinate
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
        XCTAssertFlyover(flyover, controller.flyover)
        XCTAssertEqual(controller.view, controller.flyoverMapView)
        XCTAssertTrue(controller.flyoverMapView.isStarted)
        XCTAssertEqual(controller.flyoverMapView.configuration, FlyoverCamera.Configuration.Theme.default.rawValue)
        XCTAssertEqual(controller.flyoverMapView.flyoverMapType, .standard)
        flyover = FlyoverAwesomePlace.googlePlex
        controller.flyover = flyover
        XCTAssertFlyover(flyover, controller.flyover)
        XCTAssertTrue(controller.flyoverMapView.isStarted)
    }
    
    func testFlyoverMapViewControllerThemeInitializer() {
        let flyover = FlyoverAwesomePlace.googlePlex
        let controller = FlyoverMapViewController(flyover: flyover, configurationTheme: .farAway, mapType: .satelliteFlyover)
        XCTAssertFlyover(flyover, controller.flyover)
        XCTAssertEqual(controller.flyoverMapView.configuration, FlyoverCamera.Configuration.Theme.farAway.rawValue)
        XCTAssertEqual(controller.flyoverMapView.flyoverMapType, .satelliteFlyover)
    }
    
}

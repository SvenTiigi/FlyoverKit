//
//  FlyoverCameraTests.swift
//  FlyoverKitTests
//
//  Created by Sven Tiigi on 24.02.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

@testable import FlyoverKit
import MapKit
import XCTest

class FlyoverCameraTests: BaseTests {
    
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
        XCTAssertEqual(configuration1, configuration2)
    }
    
    func testFlyoverCameraDefaultInitializerConfiguration() {
        let mapView = MKMapView()
        let flyoverCamera = FlyoverCamera(mapView: mapView)
        XCTAssertEqual(flyoverCamera.configuration, .default)
    }
    
    func testFlyoverCameraConfigurationTheme() {
        let mapView = MKMapView()
        let configurationThemes: [FlyoverCamera.Configuration] = [
            .default,
            .lowFlying,
            .farAway,
            .giddy,
            .astronautView
        ]
        configurationThemes.forEach { (theme) in
            let flyoverCamera = FlyoverCamera(mapView: mapView, configuration: theme)
            XCTAssertEqual(flyoverCamera.configuration, theme)
        }
    }
    
    func testFlyoverCameraStartStop() {
        let mapView = MKMapView()
        let flyoverCamera = FlyoverCamera(mapView: mapView)
        XCTAssertFalse(flyoverCamera.state == .started)
        flyoverCamera.start(flyover: FlyoverAwesomePlace.parisEiffelTower)
        XCTAssertTrue(flyoverCamera.state == .started)
        flyoverCamera.stop()
        XCTAssertFalse(flyoverCamera.state == .started)
        flyoverCamera.configuration.regionChangeAnimation = .animated(duration: 0.1, curve: .linear)
        flyoverCamera.configuration.duration = 0.1
        flyoverCamera.start(flyover: FlyoverAwesomePlace.appleHeadquarter)
        self.performTest(#function) { (expectation) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                XCTAssertTrue(flyoverCamera.state == .started)
                flyoverCamera.start(flyover: FlyoverAwesomePlace.googlePlex)
                XCTAssertTrue(flyoverCamera.state == .started)
                flyoverCamera.stop()
                XCTAssertFalse(flyoverCamera.state == .started)
                expectation.fulfill()
            })
        }
    }
    
}

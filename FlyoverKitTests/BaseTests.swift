//
//  BaseTests.swift
//  FlyoverKitTests
//
//  Created by Sven Tiigi on 24.02.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import CoreLocation
@testable import FlyoverKit
import XCTest

// MARK: - BaseTests

class BaseTests: XCTestCase {
    
    /// The timeout value while waiting
    /// that an expectation is fulfilled
    let expectationTimeout: TimeInterval = 10.0
    
    /// Random Double Value
    var randomDouble: Double {
        let random = Double(arc4random()) / 0xFFFFFFFF
        return random * (80 - 10) + 10
    }
    
    /// Random CLLocationCoordinate2D
    var randomCoordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.randomDouble, longitude: self.randomDouble)
    }
    
    /// SetUp
    override func setUp() {
        super.setUp()
        // Disable continueAfterFailure
        self.continueAfterFailure = false
    }
    
    /// Perform test with expectation
    ///
    /// - Parameters:
    ///   - name: The expectation name
    ///   - execution: The test execution
    func performTest(_ expectationName: String, _ timeout: TimeInterval? = nil,
                     _ execution: (XCTestExpectation) -> Void) {
        // Create expectation with function name
        let expectation = self.expectation(description: expectationName)
        // Perform test execution with expectation
        execution(expectation)
        // Wait for expectation been fulfilled with custom or default timeout
        self.waitForExpectations(timeout: timeout.flatMap { $0 } ?? self.expectationTimeout, handler: nil)
    }
    
}

// MARK: - XCTestCase AssertFlyover

extension XCTestCase {
    
    /// Assert that two given Flyover objects are equal by comparing latitude and longitude
    ///
    /// - Parameters:
    ///   - flyover1: The first Flyover object
    ///   - flyover2: The second Flyover object
    func XCTAssertFlyover(_ flyover1: Flyover, _ flyover2: Flyover) {
        // Assert latitude
        XCTAssertEqual(flyover1.coordinate.latitude, flyover2.coordinate.latitude)
        // Assert longitude
        XCTAssertEqual(flyover1.coordinate.longitude, flyover2.coordinate.longitude)
    }
    
}

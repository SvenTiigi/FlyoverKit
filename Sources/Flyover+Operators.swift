//
//  Flyover+Operators.swift
//  FlyoverKit
//
//  Created by Sven Tiigi on 28.02.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import Foundation

infix operator ~~

public extension Optional where Wrapped == Flyover {

    /// Compare two given Flyover types
    ///
    /// - Parameters:
    ///   - lhs: The left hand side
    ///   - rhs: The right hand side
    /// - Returns: Boolean if the two given Flyover's are exactly equal
    static func == (lhs: Flyover?, rhs: Flyover?) -> Bool {
        return lhs?.coordinate.latitude == rhs?.coordinate.latitude
            && lhs?.coordinate.longitude == rhs?.coordinate.longitude
    }
    
    /// Compare two given Flyover types via rounded latitude and longitude comparison
    ///
    /// - Parameters:
    ///   - lhs: The left hand side
    ///   - rhs: The right hand side
    /// - Returns: Boolean if the two given Flyover's are nearly equal (rounded)
    static func ~~ (lhs: Flyover?, rhs: Flyover?) -> Bool {
        guard let lhs = lhs?.coordinate, let rhs = rhs?.coordinate else {
            return false
        }
        let factor = 1000.0
        return round(lhs.latitude * factor) == round(rhs.latitude * factor)
            && round(lhs.longitude * factor) == round(rhs.longitude * factor)
    }
    
}

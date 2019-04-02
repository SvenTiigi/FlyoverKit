//
//  FlyoverCamera+State.swift
//  FlyoverKit
//
//  Created by Sven Tiigi on 28.02.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import Foundation

public extension FlyoverCamera {
    
    /// The FlyoverCamera State
    ///
    /// - started: The FlyoverCamera is started and running
    /// - stopped: The FlyoverCamera is stopped (Initial-Value)
    enum State: String, Equatable, Hashable, CaseIterable {
        /// Started
        case started
        /// Stopped
        case stopped
    }
    
}

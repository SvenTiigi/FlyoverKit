import Foundation
import SwiftUI

// MARK: - Flyover+Configuration+Parameter

public extension Flyover.Configuration {
    
    /// A Flyover Configuration Parameter
    struct Parameter<Value: BinaryFloatingPoint> {
        
        // MARK: Properties
        
        /// A closure to update the Value to a new Value
        private let update: (Value) -> Value
        
        // MARK: Initializer
        
        /// Creates a new instance of `Flyover.Configuration.Parameter`
        /// - Parameter update: A closure to update the Value to a new Value
        public init(
            _ update: @escaping (Value) -> Value
        ) {
            self.update = update
        }
        
        /// Creates a new instance of `Flyover.Configuration.Parameter`
        /// - Parameter value: The Value
        public init(_ value: Value) {
            self.init { _ in value }
        }
        
        // MARK: Call as Function
        
        /// Call `Flyover.Configuration.Parameter` to retrieve/update its Value
        /// - Parameter value: The current Value
        /// - Returns: The new Value
        public func callAsFunction(
            _ value: Value
        ) -> Value {
            self.update(value)
        }
        
    }
    
}

// MARK: - ExpressibleByIntegerLiteral

extension Flyover.Configuration.Parameter: ExpressibleByIntegerLiteral {
    
    /// Creates a new instance of `Flyover.Configuration.Parameter`
    /// - Parameter value: The Integer literal
    public init(
        integerLiteral value: Int
    ) {
        self.init(.init(value))
    }
    
}

// MARK: - ExpressibleByFloatLiteral

extension Flyover.Configuration.Parameter: ExpressibleByFloatLiteral where Value: _ExpressibleByBuiltinFloatLiteral {
    
    /// Creates a new instance of `Flyover.Configuration.Parameter`
    /// - Parameter value: The Value literal
    public init(
        floatLiteral value: Value
    ) {
        self.init(value)
    }
    
}

// MARK: - Increment

public extension Flyover.Configuration.Parameter {
    
    /// Increment the Parameter Value by a given Value
    /// - Parameter value: The Value that should be incremented
    static func increment(by value: Value) -> Self {
        .init { $0 + value }
    }
    
}

// MARK: - Restricted

public extension Flyover.Configuration.Parameter {
    
    /// A restricted Parameter in a given Range
    /// - Parameters:
    ///   - parameter: The Parameter
    ///   - range: The Range
    static func restricted(
        _ parameter: Self,
        in range: ClosedRange<Value>
    ) -> Self {
        .init { max(min(parameter($0), range.upperBound), range.lowerBound) }
    }
    
}

import UIKit

// MARK: - Flyover+Animator

extension Flyover {
    
    /// A Flyover Animator
    final class Animator {
        
        /// The UIViewPropertyAnimator
        private var propertyAnimator: UIViewPropertyAnimator?
        
    }
    
}

// MARK: - Start

extension Flyover.Animator {
    
    /// Start animations
    /// - Parameters:
    ///   - duration: The duration of the animation, in seconds
    ///   - curve: The UIKit timing curve to apply to the animation
    ///   - animations: A closure containing the animations
    ///   - completion: A closure to execute when the animations ends
    func start(
        duration: TimeInterval,
        curve: UIView.AnimationCurve,
        animations: @escaping () -> Void,
        completion: @escaping () -> Void
    ) {
        // Initialize a new property animator
        let propertyAnimator = UIViewPropertyAnimator(
            duration: duration,
            curve: curve,
            animations: animations
        )
        // Add completion
        propertyAnimator.addCompletion { [weak self] finalPosition in
            // Verify final position is end
            guard finalPosition == .end && self?.propertyAnimator != nil else {
                // Otherwise return out of function
                return
            }
            // Invoke completion
            completion()
        }
        // Start animation
        propertyAnimator.startAnimation()
        // Retain property animator
        self.propertyAnimator = propertyAnimator
    }
    
}

// MARK: - Stop

extension Flyover.Animator {
    
    /// Stop animations
    /// - Returns: The completion percentage of the animation, if available
    @discardableResult
    func stop() -> CGFloat? {
        // Verify a property animator is available
        guard let propertyAnimator = self.propertyAnimator else {
            // Otherwise return nil
            return nil
        }
        // Retrieve the completion percentage of the animation
        let fractionComplete = propertyAnimator.fractionComplete
        // Stop animation
        propertyAnimator.stopAnimation(true)
        // Clear property animator reference
        self.propertyAnimator = nil
        // Return fraction completion percentage
        return fractionComplete
    }
    
}

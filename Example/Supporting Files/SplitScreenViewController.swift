//
//  SplitScreenViewController.swift
//  FlyoverKit-Example
//
//  Created by Sven Tiigi on 01.03.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import UIKit

/// The SplitScreenViewController
open class SplitScreenViewController: UIViewController {
    
    // MARK: Properties
    
    /// The TopView
    private let topView: UIView
    
    /// The BottomView
    private let bottomView: UIView
    
    /// The configuration
    private let configuration: Configuration
    
    /// The drag view
    private lazy var dragView: UIView = {
        return UIView.getUserInteractionEnabledView()
    }()
    
    /// The drag inner view
    private lazy var dragInnerView: UIView = {
        return UIView.getUserInteractionEnabledView()
    }()
    
    /// The UIPanGestureRecognizer
    private lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        return UIPanGestureRecognizer(target: self, action: #selector(handleDrag(_:)))
    }()
    
    /// Computed view height
    private var viewHeight: CGFloat {
        return self.view.frame.size.height
    }
    
    /// Computed view width
    private var viewWidth: CGFloat {
        return self.view.frame.size.width
    }
    
    // MARK: Initializers
    
    /// Default initializer with TopView, BottomView and Configuration
    ///
    /// - Parameters:
    ///   - topView: The TopView
    ///   - bottomView: The BottomView
    ///   - configuration: The SplitScreenViewController.Configuration
    public init(topView: UIView, bottomView: UIView, configuration: Configuration = .init()) {
        // Set TopView
        self.topView = topView
        // Set BottomView
        self.bottomView = bottomView
        // Set Configuration
        self.configuration = configuration
        // Super init
        super.init(nibName: nil, bundle: nil)
        // Set Backgroundcolor white
        self.view.backgroundColor = .white
        // Add drag inner view to drag view
        self.dragView.addSubview(self.dragInnerView)
        // Add subviews
        [self.topView, self.bottomView, self.dragView].forEach(self.view.addSubview)
        // Add gesture recognizer on drag view
        self.dragView.addGestureRecognizer(self.panGestureRecognizer)
        // Set drag view background color
        self.dragView.backgroundColor = self.configuration.dragView.backgroundColor
        // Set drag inner view background color
        self.dragInnerView.backgroundColor = self.configuration.dragInnerView.backgroundColor
        // Set drag inner view alpha
        self.dragInnerView.alpha = self.configuration.dragInnerView.alpha
        // Set drag inner view corner radius
        self.dragInnerView.layer.cornerRadius = self.configuration.dragInnerView.cornerRadius
        // Clear edges for extended 
        self.edgesForExtendedLayout = []
    }
    
    /// Convenience initializer with TopView, BottomView and Configuration Closure
    ///
    /// - Parameters:
    ///   - topView: The TopView
    ///   - bottomView: The BottomView
    ///   - configuration: The SplitScreenViewController.Configuration Closure
    public convenience init(topView: UIView, bottomView: UIView, configuration: (inout Configuration) -> Void) {
        // Initialize configuration
        var config = Configuration()
        // Perform configuration with config
        configuration(&config)
        // Init with topView, bottomView and config
        self.init(
            topView: topView,
            bottomView: bottomView,
            configuration: config
        )
    }
    
    /// Convenience initializer with TopViewController, BottomViewController and Configuration
    ///
    /// - Parameters:
    ///   - topViewController: The TopViewController
    ///   - bottomViewController: The BottomViewController
    ///   - configuration: The SplitScreenViewController.Configuration
    public convenience init(topViewController: UIViewController, bottomViewController: UIViewController,
                            configuration: Configuration = .init()) {
        // Self init with topView, bottomView and configuration
        self.init(
            topView: topViewController.view,
            bottomView: bottomViewController.view,
            configuration: configuration
        )
        // Add ChildViewControllers
        [topViewController, bottomViewController].forEach(self.addChildViewController)
        // DidMove to ParentViewController
        [topViewController, bottomViewController].forEach { $0.didMove(toParentViewController: self) }
    }
    
    /// Convenience initializer with TopViewController, BottomViewController and Configuration Closure
    ///
    /// - Parameters:
    ///   - topViewController: The TopViewController
    ///   - bottomViewController: The BottomViewController
    ///   - configuration: The SplitScreenViewController.Configuration Closure
    public convenience init(topViewController: UIViewController, bottomViewController: UIViewController,
                            configuration: (inout Configuration) -> Void) {
        // Initialize configuration
        var config = Configuration()
        // Perform configuration with config
        configuration(&config)
        // Init with topViewController, bottomViewController and config
        self.init(
            topViewController: topViewController,
            bottomViewController: bottomViewController,
            configuration: config
        )
    }
    
    /// NSCoder Initializer (not supported) returns nil
    public required init?(coder aDecoder: NSCoder) {
        // Return nil
        return nil
    }
    
    // MARK: View-Lifecycle
    
    /// ViewDidLayoutSubView
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Check if drag view frame hasn't been set
        if self.dragView.frame == CGRect.zero {
            // Set drag view Frame
            self.dragView.frame.origin.x = 0
            self.dragView.frame.origin.y = self.viewHeight / 2 - self.configuration.dragView.height / 2
            self.dragView.frame.origin.y += self.configuration.dragView.startYPadding
        }
        // Always Update DragView Width
        self.dragView.frame.size.width = self.viewWidth
        self.dragView.frame.size.height = self.configuration.dragView.height
        // Initialize dragInnerViewHeigh
        let dragInnerViewHeight = self.dragView.frame.size.height - self.configuration.dragInnerView.heightPadding * 2
        // Set drag inner view frame
        self.dragInnerView.frame = CGRect(
            x: self.dragView.frame.size.width / 2 - self.configuration.dragInnerView.width / 2,
            y: self.dragView.frame.size.height / 2 - dragInnerViewHeight / 2,
            width: self.configuration.dragInnerView.width,
            height: dragInnerViewHeight
        )
        // Set TopView Frame
        self.topView.frame = CGRect(
            x: 0,
            y: 0,
            width: self.viewWidth,
            height: self.dragView.frame.origin.y
        )
        // Set BottomView Frame
        self.bottomView.frame = CGRect(
            x: 0,
            y: self.dragView.frame.origin.y + self.configuration.dragView.height,
            width: self.viewWidth,
            height: self.viewHeight - self.dragView.frame.origin.y
        )
    }
    
    // MARK: UIPanGestureRecognizer Handler
    
    /// Handle UIPanGestureRecognizer drag
    ///
    /// - Parameter sender: The UIPanGestureRecognizer
    @objc private func handleDrag(_ sender: UIPanGestureRecognizer) {
        // Initialize gesturerecoggnizer translation for view
        let translation = sender.translation(in: self.view)
        // Initialize the updated Y origin
        let updatedYOrigin = self.dragView.center.y + translation.y
        // Check if the new y origin is too small
        if updatedYOrigin <= self.configuration.dragThreshold.minY {
            // Reached minY threshold
            return
        }
        // Check if the new y origin is too big
        if updatedYOrigin >= self.viewHeight - self.configuration.dragThreshold.maxY {
            // Reached maxY threshold
            return
        }
        // Update splitViewDrag center
        self.dragView.center = CGPoint(x: self.dragView.center.x, y: updatedYOrigin)
        // Set view needs layout in order to update the layout
        self.view.setNeedsLayout()
        // Reset translation
        sender.setTranslation(CGPoint.zero, in: self.view)
    }
    
}

// MARK: - SplitScreenViewController.Configuration

public extension SplitScreenViewController {
    
    /// The SplitScreenViewController Configuration
    struct Configuration {
        
        // MARK: Properties
        
        // The DragThreshold
        public var dragThreshold: DragThreshold
        
        /// The DragView
        public var dragView: DragView
        
        /// The DragInnerView
        public var dragInnerView: DragInnerView
        
        // MARK: Initializer
        
        /// Default initializer
        public init() {
            // Init with default values
            self.init(
                dragThreshold: (
                    minY: 100,
                    maxY: 100
                ),
                dragView: (
                    height: 15,
                    backgroundColor: UIColor(red: 31/255, green: 31/255, blue: 33/255, alpha: 1),
                    startYPadding: 0
                ),
                dragInnerView: (
                    width: 80,
                    heightPadding: 5,
                    cornerRadius: 5,
                    backgroundColor: UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 0.8),
                    alpha: 0.8
                )
            )
        }
        
        /// Initializer with DragThreshold, DragView and DragInnerView configuration
        ///
        /// - Parameters:
        ///   - dragThreshold: The DragThreshold configuration
        ///   - dragView: The DragView configuration
        ///   - dragInnerView: The DragInnerView configuration
        public init(dragThreshold: DragThreshold, dragView: DragView, dragInnerView: DragInnerView) {
            self.dragThreshold = dragThreshold
            self.dragView = dragView
            self.dragInnerView = dragInnerView
        }
        
    }
    
}

public extension SplitScreenViewController.Configuration {
    
    /// The DragThreshold configuration type
    typealias DragThreshold = (
        minY: CGFloat,
        maxY: CGFloat
    )
    
    /// The DragView configuration type
    typealias DragView = (
        height: CGFloat,
        backgroundColor: UIColor,
        startYPadding: CGFloat
    )
    
    /// The DragInnerView configuration type
    typealias DragInnerView = (
        width: CGFloat,
        heightPadding: CGFloat,
        cornerRadius: CGFloat,
        backgroundColor: UIColor,
        alpha: CGFloat
    )
    
}

// MARK: - UIView getUserInteractionEnabledView

extension UIView {
    
    /// Retrieve an UIView which user interaction is enabled
    ///
    /// - Returns: The preconfigured view
    static func getUserInteractionEnabledView() -> UIView {
        // Initialize the UIView
        let view = UIView()
        // Set user interaction enabled to true
        view.isUserInteractionEnabled = true
        // Return view
        return view
    }
    
}

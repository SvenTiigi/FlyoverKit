//
//  ViewController.swift
//  FlyoverKitExample
//
//  Created by Sven Tiigi on 21.02.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import FlyoverKit
import MapKit
import SafariServices
import SnapKit
import UIKit

// MARK: - ViewController

/// The Example View Controller
class ViewController: SplitScreenViewController {
    
    // MARK: Propertirs

    /// The FlyoverMapView
    private var flyoverMapView: FlyoverMapView

    /// The ConfigurationTableView
    private var configurationTableView: FlyoverConfigurationTableView
    
    /// The example location
    // Change the enum case to explore different locations 🤙
    let location = FlyoverAwesomePlace.parisEiffelTower
    
    /// Boolean if MapView is in Full-Screen Mode
    var isMapFullscreen = false
    
    /// Boolean holding Flyover start/stop state
    var flyoverWasStarted = true
    
    // MARK: Initializer
    
    /// Default initializer
    init() {
        // Initialize SplitScreenViewController Configuration
        var configuration = Configuration()
        // Set main backgroundcolor
        configuration.dragView.backgroundColor = .main
        // Add y padding
        configuration.dragView.startYPadding = 20
        // Set white inner drag view background color
        configuration.dragInnerView.backgroundColor = .white
        // Initialize FlyoverMapView
        self.flyoverMapView = FlyoverMapView(configurationTheme: .default)
        // Initialize ConfigurationTableView
        self.configurationTableView = FlyoverConfigurationTableView()
        // Super init
        super.init(topView: self.flyoverMapView, bottomView: self.configurationTableView, configuration: configuration)
        // Set ConfigurationDelegate
        self.configurationTableView.configurationDelegate = self
    }
    
    /// Initializer with NSCoder always return nil
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    // MARK: ViewLifeCycle
    
    /// ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set white background color
        self.view.backgroundColor = .white
        // Add Navigation Items
        self.addNavigationItems()
    }
    
    /// viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Check if flyover was started before starting
        if self.flyoverWasStarted {
            // Start
            self.flyoverMapView.start(flyover: self.location)
        }
    }
    
    /// viewDidDisappear
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // Store state
        self.flyoverWasStarted = self.flyoverMapView.state == .started
        // Stop
        self.flyoverMapView.stop()
    }

    // MARK: Custom Functions
    
    /// Add navigation items
    private func addNavigationItems() {
        self.title = "FlyoverKit"
        let githubBarButtonItem = UIBarButtonItem(
            image: #imageLiteral(resourceName: "github"),
            style: .plain,
            target: self,
            action: #selector(githubBarButtonItemTouched(_:))
        )
        self.navigationItem.rightBarButtonItem = githubBarButtonItem
    }
    
    /// Github BarButtonItem touched handler
    @objc private func githubBarButtonItemTouched(_ sender: UIBarButtonItem) {
        guard let url = URL(string: "https://github.com/SvenTiigi/FlyoverKit/blob/master/README.md") else {
            print("Unable to construct Github Repo URL")
            return
        }
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.preferredControlTintColor = .main
        self.present(safariViewController, animated: true)
    }
    
}

// MARK: - ConfigurationTableViewDelegate

extension ViewController: FlyoverConfigurationTableViewDelegate {
    
    /// On Configuration Change
    ///
    /// - Parameter configuration: The updated configuration
    func onChange(_ configuration: FlyoverConfiguration) {
        // Switch on configuration
        switch configuration {
        case .flyover(let started):
            // Check flyover started/stop state
            if started {
                // Start
                self.flyoverMapView.start(flyover: self.location)
            } else {
                // Stop
                self.flyoverMapView.stop()
            }
        case .mapType(let mapType):
            // Set MapView Type
            self.flyoverMapView.mapType = mapType
        case .duration(let duration):
            // Set duration
            self.flyoverMapView.configuration.duration = duration
        case .altitude(let altitude):
            // Set altitude
            self.flyoverMapView.configuration.altitude = altitude
        case .pitch(let pitch):
            // Set pitch
            self.flyoverMapView.configuration.pitch = pitch
        case .headingStep(let headingStep):
            // Set headingStep
            self.flyoverMapView.configuration.headingStep = headingStep
        }
    }
    
}

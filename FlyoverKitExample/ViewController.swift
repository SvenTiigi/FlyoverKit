//
//  ViewController.swift
//  FlyoverKitExample
//
//  Created by Sven Tiigi on 21.02.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import UIKit
import MapKit
import SnapKit
import SafariServices
import FlyoverKit

// MARK: - ViewController

/// The Example View Controller
class ViewController: UIViewController {
    
    // MARK: Propertirs

    /// The FlyoverMapView
    lazy private var flyoverMapView: FlyoverMapView = {
        return FlyoverMapView(configurationTheme: .default)
    }()

    /// The ConfigurationTableView
    lazy private var configurationTableView: ConfigurationTableView = {
        return ConfigurationTableView(configurationDelegate: self)
    }()
    
    /// The example location (Paris, Eiffel Tower)
    var location = CLLocationCoordinate2DMake(48.858370, 2.294481)
    
    /// Boolean if MapView is in Full-Screen Mode
    var isMapFullscreen = false
    
    // MARK: ViewLifeCycle
    
    /// ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set white background color
        self.view.backgroundColor = .white
        // Add Navigation Items
        self.addNavigationItems()
        // Add Subviews
        self.view.addSubview(self.flyoverMapView)
        self.view.addSubview(self.configurationTableView)
        // Layout SubViews
        self.layoutSubViews()
    }
    
    /// viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Start
        self.flyoverMapView.start(self.location)
    }
    
    /// viewDidDisappear
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // Stop
        self.flyoverMapView.stop()
    }
    
    // MARK: Layout
    
    /// Layout subviews
    private func layoutSubViews() {
        self.flyoverMapView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.left.right.equalTo(self.view)
            make.height.equalTo(self.view).multipliedBy(0.45)
        }
        self.configurationTableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.flyoverMapView.snp.bottom)
            make.left.right.bottom.equalTo(self.view)
        }
    }
    
    // MARK: Custom Functions
    
    /// Add navigation items
    private func addNavigationItems() {
        self.title = "FlyoverCameraKit"
        
        let actionBarButtonItem = UIBarButtonItem(title: "Fullscreen", style: .plain, target: self, action: #selector(actionBarButtonItemTouched(_:)))
        let githubBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "github"), style: .plain, target: self, action: #selector(githubBarButtonItemTouched(_:)))
        self.navigationItem.leftBarButtonItem = actionBarButtonItem
        self.navigationItem.rightBarButtonItem = githubBarButtonItem
    }
    
    /// Handle double tap
    @objc func actionBarButtonItemTouched(_ sender: UIBarButtonItem) {
        self.flyoverMapView.snp.removeConstraints()
        self.configurationTableView.snp.removeConstraints()
        if self.isMapFullscreen {
            self.layoutSubViews()
        } else {
            self.flyoverMapView.snp.makeConstraints({ (make) in
                make.edges.equalTo(self.view.safeAreaLayoutGuide)
            })
        }
        self.isMapFullscreen = !self.isMapFullscreen
    }
    
    /// Github BarButtonItem touched handler
    @objc func githubBarButtonItemTouched(_ sender: UIBarButtonItem) {
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

extension ViewController: ConfigurationTableViewDelegate {
    
    /// On Configuration Change
    ///
    /// - Parameter configuration: The updated configuration
    func onChange(_ configuration: Configuration) {
        // Switch on configuration
        switch configuration {
        case .flyover(let started):
            // Check flyover started/stop state
            if started {
                // Start
                self.flyoverMapView.start(self.location)
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

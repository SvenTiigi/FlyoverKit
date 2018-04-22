//
//  FlyoverConfigurationTableView.swift
//  FlyoverKit-Example
//
//  Created by Sven Tiigi on 21.02.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import UIKit

// MARK: - FlyoverConfigurationTableViewDelegate

/// The FlyoverConfigurationTableViewDelegate
protocol FlyoverConfigurationTableViewDelegate: class {
    /// On Configuration Change
    ///
    /// - Parameter configuration: The updated configuration
    func onChange(_ configuration: FlyoverConfiguration)
}

// MARK: - FlyoverConfigurationTableView

class FlyoverConfigurationTableView: UITableView {
    
    // MARK: Properties
    
    /// The FlyoverConfigurationTableViewDelegate
    weak var configurationDelegate: FlyoverConfigurationTableViewDelegate?
    
    /// The cells constructed with default configuration and delegate
    lazy private var cells: [FlyoverConfigurationTableViewCell] = {
        // Initialize default configurations
        let defaultConfigurations: [FlyoverConfiguration] = [
            .flyover(true),
            .mapType(.standard),
            .altitude(600.0),
            .pitch(45.0),
            .headingStep(20.0),
            .duration(4.0)
        ]
        return defaultConfigurations.map { FlyoverConfigurationTableViewCell($0, self.configurationDelegate) }
    }()
    
    // MARK: Initializer
    
    /// Default initializer
    init() {
        // Super init
        super.init(frame: .zero, style: .plain)
        // Set delegate to self
        self.delegate = self
        // Set datasource to self
        self.dataSource = self
        // Clear TableFooterView
        self.tableFooterView = UIView()
        // Add bottom space
        self.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
    }
    
    /// Initializer with NSCoder returns nil
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
}

// MARK: - UITableViewDataSource

extension FlyoverConfigurationTableView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return 1 section
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return count of cells
        return self.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Return cell at index path
        return self.cells[indexPath.row]
    }
    
}

// MARK: - UITableViewDelegate

extension FlyoverConfigurationTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // First two rows smaller then the rest
        return indexPath.row < 2 ? 65 : 100
    }
    
}

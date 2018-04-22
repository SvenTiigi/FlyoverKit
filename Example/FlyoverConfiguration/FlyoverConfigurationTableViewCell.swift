//
//  FlyoverConfigurationTableViewCell.swift
//  FlyoverKit-Example
//
//  Created by Sven Tiigi on 21.02.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import MapKit
import UIKit

// MARK: - FlyoverConfigurationTableViewCell

class FlyoverConfigurationTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    /// The Configuration
    var configuration: FlyoverConfiguration
    
    /// The FlyoverConfigurationTableViewDelegate
    weak var delegate: FlyoverConfigurationTableViewDelegate?
    
    /// The title label
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    /// The value label
    lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.textAlignment = .right
        return label
    }()
    
    /// The slider
    lazy var slider: UISlider = {
        let slider = UISlider()
        slider.tintColor = .main
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        slider.addTarget(self, action: #selector(sliderValueDidChanged), for: [.touchUpInside, .touchUpOutside])
        return slider
    }()
    
    /// The switch flyover (start/stop)
    lazy var switchFlyover: UISwitch = {
        let switchFlyover = UISwitch()
        switchFlyover.tintColor = .main
        switchFlyover.onTintColor = .main
        switchFlyover.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        return switchFlyover
    }()
    
    /// The segmented control
    lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Standard", "SatelliteFlyover", "HybridFlyover"])
        segmentedControl.tintColor = .main
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        return segmentedControl
    }()
    
    // MARK: Initializer
    
    /// Default initializer with Configuration and Delegate
    ///
    /// - Parameters:
    ///   - configuration: The Configuration
    ///   - delegate: The Delegate
    init(_ configuration: FlyoverConfiguration, _ delegate: FlyoverConfigurationTableViewDelegate?) {
        // Set configuration
        self.configuration = configuration
        // Set delegate
        self.delegate = delegate
        // Super Init
        super.init(style: .default, reuseIdentifier: configuration.rawValue)
        // Set clear background color
        self.backgroundColor = .clear
        // Disable selection style
        self.selectionStyle = .none
        // Switch on configuration to configure and add subviews
        switch configuration {
        case .flyover(let started):
            self.titleLabel.text = self.configuration.getDisplayName()
            self.switchFlyover.isOn = started
            self.contentView.addSubview(self.titleLabel)
            self.contentView.addSubview(self.switchFlyover)
        case .mapType:
            self.segmentedControl.selectedSegmentIndex = 0
            self.contentView.addSubview(self.segmentedControl)
        case .duration(let duration):
            self.addSliderConfigurationViews(value: duration)
        case .altitude(let altitude):
            self.addSliderConfigurationViews(value: altitude)
        case .pitch(let pitch):
            self.addSliderConfigurationViews(value: pitch)
        case .headingStep(let headingStep):
            self.addSliderConfigurationViews(value: headingStep)
        }
    }

    /// Initializer with decoder returns nil
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    // MARK: View-Lifecycle
    
    /// LayoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        let height = self.contentView.frame.size.height
        let width = self.contentView.frame.size.width
        if case .flyover = self.configuration {
            self.switchFlyover.frame = CGRect(
                x: width - self.switchFlyover.frame.size.width - 15,
                y: height/2 - self.switchFlyover.frame.size.height / 2,
                width: self.switchFlyover.frame.size.width,
                height: self.switchFlyover.frame.size.height
            )
            self.titleLabel.frame = CGRect(
                x: 15,
                y: 0,
                width: self.switchFlyover.frame.origin.x,
                height: height
            )
        } else if case .mapType = self.configuration {
            self.segmentedControl.frame = CGRect(
                x: 18,
                y: (height / 2) - (height - 18 * 2) / 2,
                width: width - 18 * 2,
                height: height - 18 * 2
            )
        } else {
            self.valueLabel.frame = CGRect(
                x: width / 2,
                y: 0, width:
                width / 2 - 15,
                height: height / 2
            )
            self.titleLabel.frame = CGRect(
                x: 15,
                y: 0,
                width: self.valueLabel.frame.origin.x,
                height: height / 2
            )
            self.slider.frame = CGRect(
                x: 15,
                y: height / 2,
                width: width - 15 * 2,
                height: height / 2
            )
        }
    }
    
    /// Add Slider Configuration Views
    ///
    /// - Parameter value: The slider value
    func addSliderConfigurationViews(value: Double) {
        self.titleLabel.text = self.configuration.getDisplayName()
        self.valueLabel.text = String(describing: value)
        self.slider.minimumValue = configuration.getMinimumValue()
        self.slider.maximumValue = configuration.getMaximumValue()
        self.slider.value = Float(value)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.valueLabel)
        self.contentView.addSubview(self.slider)
    }
    
    // MARK: Action Handler
    
    /// Switch value changed action handler
    @objc private func switchValueChanged() {
        // Check if case is flyover and retrieve associated value bool
        if case .flyover(let started) = self.configuration {
            // Update configuration with inverted bool value
            self.configuration = .flyover(!started)
            // OnChange with update configuration
            self.delegate?.onChange(self.configuration)
        }
    }
    
    /// Slider value changed action handler
    @objc private func sliderValueChanged() {
        // Set rounded slider value
        self.slider.value = roundf(self.slider.value)
        // Set value label text
        self.valueLabel.text = String(describing: self.slider.value)
    }
    
    /// Slider value did changed action handler
    @objc private func sliderValueDidChanged() {
        // Set rounded slider value
        self.slider.value = roundf(self.slider.value)
        // Set value label text
        self.valueLabel.text = String(describing: self.slider.value)
        // Initialize value of Double slider value type
        let value = Double(self.slider.value)
        // Declare updated configuration
        let updatedConfiguration: FlyoverConfiguration?
        // Switch on configuration
        switch self.configuration {
        case .duration:
            updatedConfiguration = .duration(value)
        case .altitude:
            updatedConfiguration = .altitude(value)
        case .pitch:
            updatedConfiguration = .pitch(value)
        case .headingStep:
            updatedConfiguration = .headingStep(value)
        default:
            updatedConfiguration = nil
        }
        // Unwrap updatedConfigration
        guard let configuration = updatedConfiguration else {
            // Not available return
            return
        }
        // Set the configuration
        self.configuration = configuration
        // OnChange with updated configuration
        self.delegate?.onChange(self.configuration)
    }
    
    /// SegmentedControl value changed action handler
    @objc private func segmentedControlValueChanged() {
        // Switch on selectedSegmentIndex
        switch self.segmentedControl.selectedSegmentIndex {
        case 0:
            self.configuration = .mapType(.standard)
        case 1:
            self.configuration = .mapType(.satelliteFlyover)
        case 2:
            self.configuration = .mapType(.hybridFlyover)
        default:
            self.configuration = .mapType(.standard)
        }
        // OnChange with updated configuration
        self.delegate?.onChange(self.configuration)
    }
    
}

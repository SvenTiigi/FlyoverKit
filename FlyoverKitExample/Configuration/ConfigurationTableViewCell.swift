//
//  ConfigurationTableViewCell.swift
//  FlyoverKitExample
//
//  Created by Sven Tiigi on 21.02.18.
//  Copyright © 2018 Sven Tiigi. All rights reserved.
//

import UIKit
import MapKit

// MARK: - ConfigurationTableViewCell

class ConfigurationTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    /// The Configuration
    var configuration: Configuration
    
    /// The ConfigurationTableViewDelegate
    weak var delegate: ConfigurationTableViewDelegate?
    
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
    init(_ configuration: Configuration, _ delegate: ConfigurationTableViewDelegate?) {
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
        // Layout Views
        self.layoutViews()
    }

    /// Initializer with decoder returns nil
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    // MARK: Layout
    
    /// Layout Subviews
    private func layoutViews() {
        if case .flyover = self.configuration {
            self.switchFlyover.snp.makeConstraints({ (make) in
                make.right.equalTo(self.contentView).offset(-15)
                make.centerY.equalTo(self.contentView)
            })
            self.titleLabel.snp.makeConstraints({ (make) in
                make.left.equalTo(self.contentView).offset(15)
                make.top.bottom.equalTo(self.contentView)
            })
        } else if case .mapType = self.configuration {
            self.segmentedControl.snp.makeConstraints({ (make) in
                make.centerX.centerY.equalTo(self.contentView)
            })
        } else {
            self.slider.snp.makeConstraints { (make) in
                make.left.equalTo(self.contentView).offset(15)
                make.right.equalTo(self.contentView).offset(-15)
                make.bottom.equalTo(self.contentView).offset(-10)
            }
            self.titleLabel.snp.makeConstraints { (make) in
                make.left.equalTo(self.contentView).offset(15)
                make.top.equalTo(self.contentView)
                make.bottom.equalTo(self.slider.snp.top)
            }
            self.valueLabel.snp.makeConstraints { (make) in
                make.right.equalTo(self.contentView).offset(-15)
                make.top.equalTo(self.contentView)
                make.bottom.equalTo(self.slider.snp.top)
            }
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
        let updatedConfiguration: Configuration?
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

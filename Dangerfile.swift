import Foundation
import Danger
import DangerSwiftLint

// Run SwiftLint for FlyoverKit with configuration
SwiftLint.lint(directory: "FlyoverKit", configFile: ".swiftlint.yml")

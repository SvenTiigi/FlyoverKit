import Foundation
import Danger
import DangerSwiftLint

// Initialize Danger
let danger = Danger()

// MARK: - Pull Request

if danger.git.createdFiles.count + danger.git.modifiedFiles.count - danger.git.deletedFiles.count > 10 {
    warn("Big PR, try to keep changes smaller if you can")
}

if danger.github.pullRequest.title.contains("WIP") {
    warn("PR is classed as Work in Progress")
}

// MARK: - Issue

if danger.github.issue.body.isEmpty {
    warn("Please provide a issue description")
}

// MARK: - SwiftLint

SwiftLint.lint(directory: "FlyoverKit", configFile: ".swiftlint.yml")

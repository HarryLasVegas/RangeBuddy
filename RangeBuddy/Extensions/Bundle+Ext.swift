//
//  Bundle+Ext.swift
//  RangeBuddy
//
//  Created by Stephan Weber on 14.07.26.
//

import Foundation

nonisolated
extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }

    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }

    /// Combines marketing version and build number into a single `String`
    /// - Returns: A version string:
    ///     - `"1.0 (4)"` when both the marketing version and build number are present
    ///     - The marketing version alone when the build number is missing
    ///     - `"n/a"` when the marketing version is missing
    var fullVersionDescription: String {
        guard let releaseVersionString = releaseVersionNumber else { return "n/a" }
        guard let buildVersionString = buildVersionNumber else { return releaseVersionString }
        return "\(releaseVersionString) (\(buildVersionString))"
    }
}

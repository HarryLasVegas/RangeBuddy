//
//  UserDefaults+Ext.swift
//  RangeBuddy
//
//  Created by Stephan Weber on 06.09.26.
//

import Foundation

nonisolated
extension UserDefaults {
    private static let appGroupID = "group.de.stephanweber.RangeBuddy"

    /// The App Group container shared by the app, its intents and the widget extension.
    ///
    /// This is the single source of truth for all persisted values - never use `.standard`.
    nonisolated(unsafe)
    static let shared: UserDefaults = {
        guard let defaults = UserDefaults(suiteName: appGroupID) else {
            fatalError("Could not open App Group '\(appGroupID)'. Is the capability enabled on this target?")
        }
        return defaults
    }()
}

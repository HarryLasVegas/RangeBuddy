//
//  RangeBuddyApp.swift
//  RangeBuddy
//
//  Created by Stephan Weber on 15.06.26.
//

import SwiftUI
import AppIntents

@main
struct RangeBuddyApp: App {
    init() {
        DataStore.migrateToAppGroup()
        RangeShortcuts.updateAppShortcutParameters()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

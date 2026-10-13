//
//  DataStore.swift
//  RangeBuddy
//
//  Created by Stephan Weber on 18.06.26.
//

import Foundation
import WidgetKit

/// A typed wrapper for `UserDefaults`
///
/// Use in non-View code only since it's not `@Observable`;
/// Views use `@AppStorage`.
///
/// Missing keys fall back to their `AppConstants` default.
final class DataStore {
    let userDefaults = UserDefaults.shared
    private static let migrationKey = "hasMigratedToAppGroup"

    var soc: Double {
        didSet {
            userDefaults.set(soc, forKey: AppStorageKeys.soc.rawValue)
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    var avgConsumptionInKwhPer100km: Double {
        didSet {
            userDefaults.set(avgConsumptionInKwhPer100km,
                             forKey: AppStorageKeys.avgConsumptionInKwhPer100km.rawValue)
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    var batteryCapacity: Double {
        didSet {
            userDefaults.set(batteryCapacity, forKey: AppStorageKeys.batteryCapacity.rawValue)
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    var consumptionUnitType: ConsumptionUnitType {
        didSet {
            userDefaults.set(consumptionUnitType.rawValue, forKey: AppStorageKeys.consumptionUnitType.rawValue)
            WidgetCenter.shared.reloadAllTimelines()
        }
    }

    init() {
        Self.migrateToAppGroup()

        // Register defaults so a never-set key returns its AppConstants value, not 0
        UserDefaults.shared.register(defaults: [
            AppStorageKeys.soc.rawValue: AppConstants.standardSoc,
            AppStorageKeys.avgConsumptionInKwhPer100km.rawValue: AppConstants.standardAvgConsumptionInKwhPer100km,
            AppStorageKeys.batteryCapacity.rawValue: AppConstants.standardBatteryCapacity,
            AppStorageKeys.consumptionUnitType.rawValue: AppConstants.consumptionUnitType.rawValue
            ]
        )

        self.soc = userDefaults.double(forKey: AppStorageKeys.soc.rawValue)
        self.avgConsumptionInKwhPer100km = userDefaults.double(
            forKey: AppStorageKeys.avgConsumptionInKwhPer100km.rawValue)
        self.batteryCapacity = userDefaults.double(forKey: AppStorageKeys.batteryCapacity.rawValue)
        self.consumptionUnitType = ConsumptionUnitType(
            rawValue: userDefaults.string(
                forKey: AppStorageKeys.consumptionUnitType.rawValue) ?? AppConstants.consumptionUnitType.rawValue
        ) ?? AppConstants.consumptionUnitType
    }

    /// Copies all present values of the `AppStorageKeys` from `UserDefaults.standard` to `UserDefaults.shared`
    ///
    /// Safe to call repeatedly - it does nothing after the first run. Must run before anything reads from the
    /// shared store, which is why both the app and `DataStore.init` call it.
    ///
    /// Added in 1.1. Can be removed once 1.0 is effectively out of the field: a user skipping straight from 1.0 loses
    /// nothing but their four settings and sees onboarding once.
    static func migrateToAppGroup() {
        guard UserDefaults.shared.object(forKey: Self.migrationKey) == nil else {
            return
        }

        var didMigrateValues = false

        for key in AppStorageKeys.allCases {
            if let value = UserDefaults.standard.object(forKey: key.rawValue) {
                UserDefaults.shared.set(value, forKey: key.rawValue)
                didMigrateValues = true
            }
        }

        if didMigrateValues {
            UserDefaults.shared.set(true, forKey: Self.migrationKey)
        }
    }
}

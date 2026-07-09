//
//  DataStore.swift
//  RangeBuddy
//
//  Created by Stephan Weber on 18.06.26.
//

import Foundation

/// A typed wrapper for `UserDefaults`
///
/// Use in non-View code only since it's not `@Observable`;
/// Views use `@AppStorage`.
///
/// Missing keys fall back to their `AppConstants` default.
final class DataStore {
    let userDefaults = UserDefaults.standard

    var soc: Double {
        didSet { userDefaults.set(soc, forKey: AppStorageKeys.soc.rawValue) }
    }
    var avgConsumptionInKwhPer100km: Double {
        didSet { userDefaults.set(avgConsumptionInKwhPer100km,
                                  forKey: AppStorageKeys.avgConsumptionInKwhPer100km.rawValue) }
    }
    var batteryCapacity: Double {
        didSet { userDefaults.set(batteryCapacity, forKey: AppStorageKeys.batteryCapacity.rawValue) }
    }
    var consumptionUnitType: ConsumptionUnitType {
        didSet { userDefaults.set(consumptionUnitType.rawValue, forKey: AppStorageKeys.consumptionUnitType.rawValue) }
    }

    init() {
        // Register defaults so a never-set key returns its AppConstants value, not 0
        UserDefaults.standard.register(defaults: [
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
}

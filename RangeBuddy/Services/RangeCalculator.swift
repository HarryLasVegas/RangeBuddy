//
//  RangeCalculator.swift
//  RangeBuddy
//
//  Created by Stephan Weber on 15.06.26.
//

import Foundation

nonisolated struct RangeCalculator {
    private init() {}

    /// Calculates the remaining range based on the given inputs
    /// - Parameters:
    ///   - soc: The SoC in percent
    ///   - avgConsumption: The average consumption in kWh/100km
    ///   - batteryCapacity: The battery capacity in kWh
    /// - Returns: The remaining range in km, or `0` if `avgConsumption` is not positive.
    static func rangeInKm(soc: Double, avgConsumption: Double, batteryCapacity: Double) -> Double {
        guard avgConsumption > 0 else { return 0 }
        let availableKwh = soc / 100 * batteryCapacity

        return (availableKwh / avgConsumption * 100)
    }
}

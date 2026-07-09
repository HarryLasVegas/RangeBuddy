//
//  GetRangeIntent.swift
//  RangeBuddy
//
//  Created by Stephan Weber on 16.06.26.
//

import AppIntents

struct GetRangeIntent: AppIntent {
    static let title: LocalizedStringResource = "Get Range"
    // swiftlint:disable:next line_length
    static let description: IntentDescription = "Calculates the remaining range from your saved state of charge, average consumption and battery capacity - without changing any of them."
    static let supportedModes: IntentModes = [.background]

    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        let store = DataStore()

        let soc: Double = store.soc
        let avgConsumption: Double = store.avgConsumptionInKwhPer100km
        let batteryCapacity: Double = store.batteryCapacity
        let distanceUnit: DistanceUnit = store.consumptionUnitType.distanceUnit

        let rangeInKm: Double = RangeCalculator.rangeInKm(
            soc: soc,
            avgConsumption: avgConsumption,
            batteryCapacity: batteryCapacity
        )
        let range: Int = distanceUnit.displayDistance(rangeInKm)

        return .result(dialog: "Range is: \(range) \(distanceUnit.fullLabel)")
    }
}

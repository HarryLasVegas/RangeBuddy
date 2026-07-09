//
//  SetSoCIntent.swift
//  RangeBuddy
//
//  Created by Stephan Weber on 20.06.26.
//

import AppIntents

struct SetSoCIntent: AppIntent {
    static let title: LocalizedStringResource = "Set SoC"
    // swiftlint:disable:next line_length
    static let description: IntentDescription = "Sets the state of charge you supply and reports how far the current charge now takes you."
    static let supportedModes: IntentModes = [.background]

    @Parameter(title: "SoC", requestValueDialog: "What's the new SoC?")
    var newSoc: Double

    static var parameterSummary: some ParameterSummary {
        Summary("Set SoC to \(\.$newSoc)")
    }

    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        let store = DataStore()

        guard AppConstants.socRange.contains(newSoc) else {
            let min: String = AppConstants.socRange.lowerBound.formatted(.number.precision(.fractionLength(0)))
            let max: String = AppConstants.socRange.upperBound.formatted(.number.precision(.fractionLength(0)))

            throw $newSoc.needsValueError("Value for SoC must be between \(min) and \(max).")
        }

        store.soc = newSoc
        let avgConsumption = store.avgConsumptionInKwhPer100km
        let batteryCapacity = store.batteryCapacity
        let distanceUnit: DistanceUnit = store.consumptionUnitType.distanceUnit

        let rangeInKm: Double = RangeCalculator.rangeInKm(
            soc: newSoc,
            avgConsumption: avgConsumption,
            batteryCapacity: batteryCapacity
        )
        let range: Int = distanceUnit.displayDistance(rangeInKm)
        let newSocString = newSoc.formatted(.number.precision(.fractionLength(0)))

        return .result(dialog: "SoC set to \(newSocString). Your range is \(range) \(distanceUnit.fullLabel).")
    }
}

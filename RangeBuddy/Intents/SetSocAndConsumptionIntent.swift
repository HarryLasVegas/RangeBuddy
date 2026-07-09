//
//  SetSocAndConsumptionIntent.swift
//  RangeBuddy
//
//  Created by Stephan Weber on 04.07.26.
//

import AppIntents

struct SetSocAndConsumptionIntent: AppIntent {
    static let title: LocalizedStringResource = "Set SoC and Consumption"
    // swiftlint:disable:next line_length
    static let description: IntentDescription = "Sets the state of charge and average consumption you supply in one step, then reports the new range."
    static let supportedModes: IntentModes = [.background]

    @Parameter(title: "SoC", requestValueDialog: "What's the new SoC?")
    var newSoc: Double

    @Parameter(title: "Consumption", requestValueDialog: "What's the new consumption?")
    var newConsumption: Double

    static var parameterSummary: some ParameterSummary {
        Summary("Set SoC to \(\.$newSoc) and consumption to \(\.$newConsumption)")
    }

    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        let store = DataStore()

        guard AppConstants.avgConsumptionInKwhPer100kmRange.contains(newConsumption) else {
            let consumption = AppConstants.avgConsumptionInKwhPer100kmRange
            let format: FloatingPointFormatStyle<Double> = .number.precision(.fractionLength(0))

            let min = consumption.lowerBound.formatted(format)
            let max = consumption.upperBound.formatted(format)

            throw $newConsumption.needsValueError("Value for Consumption must be between \(min) and \(max).")
        }

        guard AppConstants.socRange.contains(newSoc) else {
            let min: String = AppConstants.socRange.lowerBound.formatted(.number.precision(.fractionLength(0)))
            let max: String = AppConstants.socRange.upperBound.formatted(.number.precision(.fractionLength(0)))

            throw $newSoc.needsValueError("Value for SoC must be between \(min) and \(max).")
        }

        store.avgConsumptionInKwhPer100km = newConsumption
        store.soc = newSoc
        let batteryCapacity = store.batteryCapacity
        let distanceUnit: DistanceUnit = store.consumptionUnitType.distanceUnit

        let rangeInKm: Double = RangeCalculator.rangeInKm(
            soc: newSoc,
            avgConsumption: newConsumption,
            batteryCapacity: batteryCapacity
        )

        let range: Int = distanceUnit.displayDistance(rangeInKm)
        let newConsumptionString = newConsumption.formatted(.number.precision(.fractionLength(1)))
        let newSocString = newSoc.formatted(.number.precision(.fractionLength(0)))

        // swiftlint:disable:next line_length
        return .result(dialog: "SoC set to \(newSocString), Consumption set to \(newConsumptionString). Your range is \(range) \(distanceUnit.fullLabel).")
    }
}

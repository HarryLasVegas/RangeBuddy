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
        let consumptionUnitType = store.consumptionUnitType
        let consumptionRange = consumptionUnitType.consumptionRange
        let consumptionFormat: FloatingPointFormatStyle<Double> =
            .number.precision(.fractionLength(0...AppConstants.socAndConsumptionMaxFractionDigits))
        let consumptionUnitLabel = consumptionUnitType.fullLabel

        guard AppConstants.socRange.contains(newSoc) else {
            let min: String = AppConstants.socRange.lowerBound.formatted(.number.precision(.fractionLength(0)))
            let max: String = AppConstants.socRange.upperBound.formatted(.number.precision(.fractionLength(0)))

            throw $newSoc.needsValueError("Value for SoC must be between \(min) and \(max).")
        }

        guard consumptionRange.contains(newConsumption) else {
            let min = consumptionRange.lowerBound.formatted(consumptionFormat)
            let max = consumptionRange.upperBound.formatted(consumptionFormat)

            // swiftlint:disable:next line_length
            throw $newConsumption.needsValueError("Value for Consumption must be between \(min) and \(max) \(consumptionUnitLabel).")
        }

        let newConsumptionInKwhPer100km = consumptionUnitType.toCanonical(newConsumption)

        store.avgConsumptionInKwhPer100km = newConsumptionInKwhPer100km
        store.soc = newSoc

        let batteryCapacity = store.batteryCapacity
        let distanceUnit: DistanceUnit = consumptionUnitType.distanceUnit

        let rangeInKm: Double = RangeCalculator.rangeInKm(
            soc: newSoc,
            avgConsumption: newConsumptionInKwhPer100km,
            batteryCapacity: batteryCapacity
        )

        let range: Int = distanceUnit.displayDistance(rangeInKm)
        let newConsumptionString = newConsumption.formatted(consumptionFormat)
        let newSocString = newSoc.formatted(
            .number.precision(.fractionLength(0...AppConstants.socAndConsumptionMaxFractionDigits)))

        // swiftlint:disable:next line_length
        return .result(dialog: "SoC set to \(newSocString) percent, consumption set to \(newConsumptionString) \(consumptionUnitLabel). Your range is \(range) \(distanceUnit.fullLabel).")
    }
}

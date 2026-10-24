//
//  SetConsumptionIntent.swift
//  RangeBuddy
//
//  Created by Stephan Weber on 21.06.26.
//

import AppIntents

struct SetConsumptionIntent: AppIntent {
    static let title: LocalizedStringResource = "Set Consumption"
    // swiftlint:disable:next line_length
    static let description: IntentDescription = "Sets the average consumption you supply and reports the range you can still drive at that consumption."
    static let supportedModes: IntentModes = [.background]

    @Parameter(title: "Consumption", requestValueDialog: "What's the new consumption?")
    var newConsumption: Double

    static var parameterSummary: some ParameterSummary {
        Summary("Set Consumption to \(\.$newConsumption)")
    }

    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        let store = DataStore()
        let consumptionUnitType = store.consumptionUnitType
        let consumptionRange = consumptionUnitType.consumptionRange
        let consumptionFormat: FloatingPointFormatStyle<Double> =
            .number.precision(.fractionLength(0...consumptionUnitType.fractionDigits))
        let unitLabel = consumptionUnitType.fullLabel

        guard consumptionRange.contains(newConsumption) else {
            let min = consumptionRange.lowerBound.formatted(consumptionFormat)
            let max = consumptionRange.upperBound.formatted(consumptionFormat)

            // swiftlint:disable:next line_length
            throw $newConsumption.needsValueError("Value for Consumption must be between \(min) and \(max) \(unitLabel).")
        }

        let newConsumptionInKwhPer100km = consumptionUnitType.toCanonical(newConsumption)
        store.avgConsumptionInKwhPer100km = newConsumptionInKwhPer100km

        let soc = store.soc
        let batteryCapacity = store.batteryCapacity
        let distanceUnit: DistanceUnit = consumptionUnitType.distanceUnit

        let rangeInKm: Double = RangeCalculator.rangeInKm(
            soc: soc,
            avgConsumption: newConsumptionInKwhPer100km,
            batteryCapacity: batteryCapacity
        )
        let range: Int = distanceUnit.displayDistance(rangeInKm)
        let newConsumptionString = newConsumption.formatted(consumptionFormat)

        return .result(
            // swiftlint:disable:next line_length
            dialog: "Consumption set to \(newConsumptionString) \(unitLabel). Your range is \(range) \(distanceUnit.fullLabel)."
        )
    }
}

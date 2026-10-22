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

        // TODO: change!
        guard AppConstants.avgConsumptionInKwhPer100kmRange.contains(newConsumption) else {
            let consumption = AppConstants.avgConsumptionInKwhPer100kmRange
            let format: FloatingPointFormatStyle<Double> = .number.precision(.fractionLength(0))

            let min = consumption.lowerBound.formatted(format)
            let max = consumption.upperBound.formatted(format)

            throw $newConsumption.needsValueError("Value for Consumption must be between \(min) and \(max).")
        }

        store.avgConsumptionInKwhPer100km = newConsumption
        let soc = store.soc
        let batteryCapacity = store.batteryCapacity
        let distanceUnit: DistanceUnit = store.consumptionUnitType.distanceUnit

        let rangeInKm: Double = RangeCalculator.rangeInKm(
            soc: soc,
            avgConsumption: newConsumption,
            batteryCapacity: batteryCapacity
        )
        let range: Int = distanceUnit.displayDistance(rangeInKm)
        let newConsumptionString = newConsumption.formatted(.number.precision(.fractionLength(1)))

        return .result(
            dialog: "Consumption set to \(newConsumptionString). Your range is \(range) \(distanceUnit.fullLabel)."
        )
    }
}

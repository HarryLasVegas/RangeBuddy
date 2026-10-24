//
//  AppConstants.swift
//  RangeBuddy
//
//  Created by Stephan Weber on 18.06.26.
//

import Foundation

nonisolated struct AppConstants {
    private init() {}

    // Please note:
    // Constants that depend on the consumption unit (range, steps, standard value)
    // live in ConsumptionUnitType

    static let consumptionUnitType: ConsumptionUnitType = .kWhPer100km

    static let standardSoc: Double = 50.0
    static let standardAvgConsumptionInKwhPer100km: Double =
        consumptionUnitType.toCanonical(consumptionUnitType.standardAvgConsumption)
    static let standardBatteryCapacity: Double = 58.0

    static let socRange: ClosedRange<Double> = 0...100
    static let batteryCapacityRange: ClosedRange<Double> = 20...150

    // SoC and consumption are shown with up to two fraction digits: odd values set
    // via Shortcuts (e.g. 15.98) stay visible, while float noise from the canonical
    // round trip does not. Anything beyond two digits is rounded.
    static let socAndConsumptionMaxFractionDigits = 2

    // Widgets show the SoC as a whole number, like the car does:
    // they are for a quick glance and have little space.
    static let widgetSocMaxFractionDigits = 0

    // MatrixWidget
    static let matrixWidgetKind = "MatrixWidget"
    static let matrixDimension: Int = 5
    static let matrixSocStepSize = 10.0

    // RangeWidget
    static let rangeWidgetKind = "RangeWidget"
    static let rangeWidgetSocSlice = 10.0
}

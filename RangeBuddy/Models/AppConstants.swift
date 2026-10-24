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

    // MatrixWidget
    static let matrixWidgetKind = "MatrixWidget"
    static let matrixDimension: Int = 5
    static let matrixSocStepSize = 10.0
    static let matrixSocMaxFractionDigits = 1

    // RangeWidget
    static let rangeWidgetKind = "RangeWidget"
    static let rangeWidgetSocSlice = 10.0
}

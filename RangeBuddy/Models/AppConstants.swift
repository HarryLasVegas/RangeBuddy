//
//  AppConstants.swift
//  RangeBuddy
//
//  Created by Stephan Weber on 18.06.26.
//

import Foundation

nonisolated struct AppConstants {
    private init() {}

    static let standardSoc: Double = 50.0
    static let standardAvgConsumptionInKwhPer100km: Double = 17.5
    static let standardBatteryCapacity: Double = 58.0

    static let socRange: ClosedRange<Double> = 0...100
    static let avgConsumptionInKwhPer100kmRange: ClosedRange<Double> = 10...35
    static let batteryCapacityRange: ClosedRange<Double> = 20...150

    static let consumptionUnitType: ConsumptionUnitType = .kWhPer100km
}

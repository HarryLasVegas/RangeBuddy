//
//  ConsumptionUnitType.swift
//  RangeBuddy
//
//  Created by Stephan Weber on 26.06.26.
//

import Foundation

nonisolated enum ConsumptionUnitType: String, CaseIterable, Identifiable {
    case kWhPer100km, milesPerKWh, whPerMile

    var id: String { self.rawValue}

    var fullUnitString: String {
        switch self {
        case .kWhPer100km: "kWh/100km"
        case .milesPerKWh: "mi/kWh"
        case .whPerMile: "Wh/mi"
        }
    }

    /// Converts a canonical (kWh/100km) value into this unit.
    /// - Parameter consumption: Consumption in kWh/100km
    /// - Returns: The consumption in this unit
    /// - Precondition: `consumption` must not be `0`
    func fromCanonical(_ consumption: Double) -> Double {
        switch self {
        case .kWhPer100km:
            return consumption
        case .milesPerKWh:
            precondition(consumption != 0, "Canonical consumption must be > 0 to convert to mi/kWh")
            return (100 / 1.609344) / consumption
        case .whPerMile:
            return consumption * 10 * 1.609344
        }
    }

    /// Converts a value in this unit into a canonical (kWh/100km) one.
    /// - Parameter displayValue: Consumption in this unit
    /// - Returns: The consumption in kWh/100km
    /// - Precondition: `displayValue` must not be `0`
    func toCanonical(_ displayValue: Double) -> Double {
        switch self {
        case .kWhPer100km:
            return displayValue
        case .milesPerKWh:
            precondition(displayValue != 0, "Display value must be > 0 to convert to canonical")
            return (100 / 1.609344) / displayValue
        case .whPerMile:
            return displayValue / (10 * 1.609344)
        }
    }

    var distanceUnit: DistanceUnit {
        switch self {
        case .kWhPer100km: .km
        case .milesPerKWh, .whPerMile: .mi
        }
    }

    var consumptionRange: ClosedRange<Double> {
        switch self {
        case .kWhPer100km: 10...35
        case .milesPerKWh: 1.8...6.2
        case .whPerMile: 165...560
        }
    }

    var standardAvgConsumption: Double {
        switch self {
        case .kWhPer100km: 17.5
        case .milesPerKWh: 3.5
        case .whPerMile: 280
        }
    }

    var adjustmentStep: Double {
        switch self {
        case .kWhPer100km: 0.5
        case .milesPerKWh: 0.1
        case .whPerMile: 5.0
        }
    }

    var comparisonStep: Double {
        switch self {
        case .kWhPer100km: 2.0
        case .milesPerKWh: 0.5
        case .whPerMile: 25.0
        }
    }

    var fractionDigits: Int {
        switch self {
        case .kWhPer100km, .milesPerKWh: 1
        case .whPerMile: 0
        }
    }

    /// `true` for units where a larger number means less energy used, like `mi/kWh`.
    ///
    /// The matrix orders its consumption axis by efficiency rather than by value,
    /// so the frugal end is always at the top - in every unit.
    var higherIsMoreEfficient: Bool {
        switch self {
        case .kWhPer100km, .whPerMile: false
        case .milesPerKWh: true
        }
    }
}

//
//  DistanceUnit.swift
//  RangeBuddy
//
//  Created by Stephan Weber on 27.06.26.
//

import Foundation

nonisolated enum DistanceUnit {
    case km, mi

    /// Converts a distance in km to a whole number in this unit.
    /// - Returns: The truncated distance in this unit.
    ///
    /// The return value is truncated rather than rounded. Better show the user a value too small than too large.
    func displayDistance(_ fromKm: Double) -> Int {
        switch self {
        case .km:
            return Int(fromKm)
        case .mi:
            return Int(fromKm / 1.609344)
        }
    }

    var shortLabel: String {
        switch self {
        case .km: "km"
        case .mi: "mi"
        }
    }

    var fullLabel: LocalizedStringResource {
        switch self {
        case .km: "Kilometers"
        case .mi: "Miles"
        }
    }
}

//
//  AxisSpec.swift
//  RangeBuddy
//
//  Created by Stephan Weber on 05.09.26.
//

import Foundation

nonisolated struct AxisSpec {
    let currentValue: Double
    let stepSize: Double
    let range: ClosedRange<Double>
    let neighborLowerBound: Double
}

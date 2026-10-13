//
//  RangeMatrix.swift
//  RangeBuddy
//
//  Created by Stephan Weber on 01.09.26.
//

import Foundation

nonisolated struct RangeMatrix {
    let socHeaders: [Double]
    let avgConsumptionHeaders: [Double]
    private let values: [[Int]]
    let currentSocIndex: Int
    let currentAvgConsumptionIndex: Int
    let consumptionUnitType: ConsumptionUnitType

    init(
        socHeaders: [Double],
        avgConsumptionHeaders: [Double],
        values: [[Int]],
        currentSocIndex: Int,
        currentAvgConsumptionIndex: Int,
        consumptionUnitType: ConsumptionUnitType
    ) {
        self.socHeaders = socHeaders
        self.avgConsumptionHeaders = avgConsumptionHeaders
        self.values = values
        self.currentSocIndex = currentSocIndex
        self.currentAvgConsumptionIndex = currentAvgConsumptionIndex
        self.consumptionUnitType = consumptionUnitType
    }

    func range(socIndex: Int, avgConsumptionIndex: Int) -> Int {
        return values[avgConsumptionIndex][socIndex]
    }
}

extension RangeMatrix {
    static let sampleMatrixDefault = RangeMatrix(
        socHeaders: [30, 40, 50, 60, 70],
        avgConsumptionHeaders: [14, 16, 17.5, 18, 20],
        values: [
          [124, 165, 207, 248, 289],
          [108, 145, 181, 217, 253],
          [99, 132, 165, 198, 231],
          [96, 128, 161, 193, 225],
          [86, 116, 145, 173, 202]
        ],
        currentSocIndex: 2,
        currentAvgConsumptionIndex: 2,
        consumptionUnitType: .kWhPer100km
    )

    static let sampleMatrix5 = RangeMatrix(
        socHeaders: [30, 40, 50, 60, 70],
        avgConsumptionHeaders: [13, 15, 17, 19.5, 21],
        values: [
            [133, 178, 223, 267, 312],
            [115, 154, 193, 231, 270],
            [102, 136, 170, 204, 238],
            [89, 118, 148, 178, 208],
            [82, 110, 138, 165, 193]
        ],
        currentSocIndex: 2,
        currentAvgConsumptionIndex: 3,
        consumptionUnitType: .kWhPer100km
    )

    static let sampleMatrixWorstCase = RangeMatrix(
          socHeaders: [60, 70, 80, 90, 100],
          avgConsumptionHeaders: [10, 11.5, 12, 14, 16],
          values: [
              [900, 1050, 1200, 1350, 1500],
              [782, 913, 1043, 1173, 1304],
              [750, 875, 1000, 1125, 1250],
              [642, 750, 857, 964, 1071],
              [562, 656, 750, 843, 937]
          ],
          currentSocIndex: 2,
          currentAvgConsumptionIndex: 1,
          consumptionUnitType: .kWhPer100km
    )

    static let sampleMatrix3 = RangeMatrix(
        socHeaders: [40, 50, 60],
        avgConsumptionHeaders: [15, 17, 19],
        values: [
            [154, 193, 232],
            [136, 170, 204],
            [122, 152, 183]
        ],
        currentSocIndex: 1,
        currentAvgConsumptionIndex: 2,
        consumptionUnitType: .kWhPer100km
    )
}

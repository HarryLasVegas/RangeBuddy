//
//  MatrixCalculatorTests.swift
//  RangeBuddyTests
//
//  Created by Stephan Weber on 08.10.26.
//

import Testing
@testable import RangeBuddy

struct MatrixCalculatorTests {

    @Test(arguments: [
        (0, [0, 10, 20, 30, 40], 0),        // 0 just once, no neighbour below
        (3, [3, 10, 20, 30, 40], 0),        // no 0-neighbour, window shifts up
        (11, [10, 11, 20, 30, 40], 1),      // lower edge, only one neighbour below
        (50, [30, 40, 50, 60, 70], 2),      // standard case, two neighbours below and above
        (47.3, [30, 40, 47.3, 50, 60], 2),  // off-grid value, neighbours are the grid points around it
        (97, [70, 80, 90, 97, 100], 3),     // upper edge, only one neighbour above
        (100, [60, 70, 80, 90, 100], 4)     // 100 just once, no neighbour above
    ])
    func socHeadersForStepTenDimensionFive(
        soc: Double,
        expectedHeaders: [Double],
        expectedSocIndex: Int
    ) {
        let stepSize = 10.0
        let matrixDimension = 5
        let unit = ConsumptionUnitType.kWhPer100km
        let batteryCapacity = 58.0
        let socRange: ClosedRange<Double> = 0...100

        let socSpec = AxisSpec(
            currentValue: soc,
            stepSize: stepSize,
            range: socRange,
            neighborLowerBound: stepSize
        )

        // Just dummy values - axis doesn't matter in this test
        // but must be available
        let avgConsumptionSpec = AxisSpec(
            currentValue: 17.5,
            stepSize: unit.comparisonStep,
            range: unit.consumptionRange,
            neighborLowerBound: unit.consumptionRange.lowerBound
        )

        let matrix = MatrixCalculator.createMatrix(
            soc: socSpec,
            avgConsumption: avgConsumptionSpec,
            batteryCapacity: batteryCapacity,
            matrixDimension: matrixDimension,
            consumptionUnitType: unit
        )

        #expect(matrix.socHeaders == expectedHeaders)
        #expect(matrix.currentSocIndex == expectedSocIndex)
    }

    @Test(arguments: [
        (10, [10, 12, 14, 16, 18], 0),      // lower edge on grid, no neighbour below
        (11, [10, 11, 12, 14, 16], 1),      // lower edge, only one neighbour below
        (17.5, [14, 16, 17.5, 18, 20], 2),  // off-grid value, neighbours are the grid points around it
        (20, [16, 18, 20, 22, 24], 2),      // standard case, two neighbours below and above
        (35, [28, 30, 32, 34, 35], 4)       // upper edge of range, not on grid, no neighbour above
    ])
    func avgConsumptionHeadersForStepTwoDimensionFive(
        avgConsumption: Double,
        expectedAvgConsumptionHeaders: [Double],
        expectedAvgConsumptionIndex: Int
    ) {
        let stepSize = 2.0
        let matrixDimension = 5
        let unit = ConsumptionUnitType.kWhPer100km
        let batteryCapacity = 58.0
        let avgConsumptionRange: ClosedRange<Double> = 10...35

        // Just dummy values - axis doesn't matter in this test
        // but must be available
        let socSpec = AxisSpec(
            currentValue: 20.0,
            stepSize: AppConstants.matrixSocStepSize,
            range: AppConstants.socRange,
            neighborLowerBound: AppConstants.matrixSocStepSize
        )

        let avgConsumptionSpec = AxisSpec(
            currentValue: avgConsumption,
            stepSize: stepSize,
            range: avgConsumptionRange,
            neighborLowerBound: avgConsumptionRange.lowerBound
        )

        let matrix = MatrixCalculator.createMatrix(
            soc: socSpec,
            avgConsumption: avgConsumptionSpec,
            batteryCapacity: batteryCapacity,
            matrixDimension: matrixDimension,
            consumptionUnitType: unit
        )

        #expect(matrix.avgConsumptionHeaders == expectedAvgConsumptionHeaders)
        #expect(matrix.currentAvgConsumptionIndex == expectedAvgConsumptionIndex)
    }

    @Test(arguments: [
        (2.0, [4.0, 3.5, 3.0, 2.5, 2.0], 4),    // lower bound, index mirrors from 0 to 4, catches missing mirroring
        (2.3, [3.5, 3.0, 2.5, 2.3, 2.0], 3),    // not on grid, index mirrors from 1 to 3, catches missing mirroring
        (3.5, [4.5, 4.0, 3.5, 3.0, 2.5], 2),    // standard case, just values have to be mirrored
        (6.0, [6.0, 5.5, 5.0, 4.5, 4.0], 0)     // upper bound, index mirrors from 4 to 0, catches missing mirroring
    ])
    func avgConsumptionHeadersReversedForMilesPerKWh(
        avgConsumption: Double,
        expectedAvgConsumptionHeaders: [Double],
        expectedAvgConsumptionIndex: Int
    ) {
        let stepSize = 0.5
        let matrixDimension = 5
        let unit = ConsumptionUnitType.milesPerKWh
        let batteryCapacity = 58.0
        let avgConsumptionRange: ClosedRange<Double> = 2...6

        // Just dummy values - axis doesn't matter in this test
        // but must be available
        let socSpec = AxisSpec(
            currentValue: 20.0,
            stepSize: AppConstants.matrixSocStepSize,
            range: AppConstants.socRange,
            neighborLowerBound: AppConstants.matrixSocStepSize
        )

        let avgConsumptionSpec = AxisSpec(
            currentValue: avgConsumption,
            stepSize: stepSize,
            range: avgConsumptionRange,
            neighborLowerBound: avgConsumptionRange.lowerBound
        )

        let matrix = MatrixCalculator.createMatrix(
            soc: socSpec,
            avgConsumption: avgConsumptionSpec,
            batteryCapacity: batteryCapacity,
            matrixDimension: matrixDimension,
            consumptionUnitType: unit
        )

        #expect(matrix.avgConsumptionHeaders == expectedAvgConsumptionHeaders)
        #expect(matrix.currentAvgConsumptionIndex == expectedAvgConsumptionIndex)
    }

    @Test func matrixIsNotTransposed() {
        let socStepSize = 10.0
        let socRange: ClosedRange<Double> = 0...100
        let soc = 50.0

        let avgConsumptionStepSize = 2.0
        let avgConsumptionRange: ClosedRange<Double> = 10...35
        let avgConsumption = 20.0

        let matrixDimension = 5
        let unit = ConsumptionUnitType.kWhPer100km
        let batteryCapacity = 50.0

        let socSpec = AxisSpec(
            currentValue: soc,
            stepSize: socStepSize,
            range: socRange,
            neighborLowerBound: socStepSize
        )

        let avgConsumptionSpec = AxisSpec(
            currentValue: avgConsumption,
            stepSize: avgConsumptionStepSize,
            range: avgConsumptionRange,
            neighborLowerBound: avgConsumptionRange.lowerBound
        )

        let matrix = MatrixCalculator.createMatrix(
            soc: socSpec,
            avgConsumption: avgConsumptionSpec,
            batteryCapacity: batteryCapacity,
            matrixDimension: matrixDimension,
            consumptionUnitType: unit
        )

        // 40 % SoC, 22 kWh/100km: 20 kWh / 22 × 100 = 90.9, truncated to 90
        #expect(matrix.range(socIndex: 1, avgConsumptionIndex: 3) == 90)

        // 60 % SoC, 18 kWh/100km: 30 kWh / 18 × 100 = 166.7, truncated to 166
        #expect(matrix.range(socIndex: 3, avgConsumptionIndex: 1) == 166)
    }

    @Test func consumptionJustBelowLowerBoundIsAccepted() {
        let avgConsumptionStepSize = 0.5
        let avgConsumptionRange: ClosedRange<Double> = 1.8...6.2

        // a value of 1.8, if saved canonical and being converted back,
        // results in 1.7999999999999998 - just below the lower bound
        let avgConsumption = 1.7999999999999998

        let matrixDimension = 5
        let unit: ConsumptionUnitType = .milesPerKWh
        let batteryCapacity = 50.0

        // Just dummy values - axis doesn't matter in this test
        // but must be available
        let socSpec = AxisSpec(
            currentValue: 20.0,
            stepSize: AppConstants.matrixSocStepSize,
            range: AppConstants.socRange,
            neighborLowerBound: AppConstants.matrixSocStepSize
        )

        let avgConsumptionSpec = AxisSpec(
            currentValue: avgConsumption,
            stepSize: avgConsumptionStepSize,
            range: avgConsumptionRange,
            neighborLowerBound: avgConsumptionRange.lowerBound
        )

        let matrix = MatrixCalculator.createMatrix(
            soc: socSpec,
            avgConsumption: avgConsumptionSpec,
            batteryCapacity: batteryCapacity,
            matrixDimension: matrixDimension,
            consumptionUnitType: unit
        )

        #expect(matrix.avgConsumptionHeaders == [3.5, 3.0, 2.5, 2.0, 1.7999999999999998])
        #expect(matrix.currentAvgConsumptionIndex == 4)
    }
}

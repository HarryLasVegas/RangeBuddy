//
//  ConsumptionUnitTypeTests.swift
//  RangeBuddyTests
//
//  Created by Stephan Weber on 10.10.26.
//

import Testing
@testable import RangeBuddy

struct ConsumptionUnitTypeTests {

    @Test(arguments: ConsumptionUnitType.allCases)
    func consumptionUnitRoundTrips(unit: ConsumptionUnitType) {
        let canonical = 17.5
        let canonicalInSelectedUnit = unit.fromCanonical(canonical)
        let tolerance = 0.001

        let result = unit.toCanonical(canonicalInSelectedUnit)
        #expect(abs(result - canonical) < tolerance)
    }

    @Test(arguments: [
        (ConsumptionUnitType.kWhPer100km, 17.5),
        (ConsumptionUnitType.milesPerKWh, 3.5507),
        (ConsumptionUnitType.whPerMile, 281.635)
    ])
    func fromCanonicalReturnsKnownValues(unit: ConsumptionUnitType, expected: Double) {
        let canonical = 17.5
        let tolerance = 0.001

        let result = unit.fromCanonical(canonical)

        #expect(abs(result - expected) < tolerance)
    }

    @Test(arguments: ConsumptionUnitType.allCases)
    func consumptionRangeBoundsAreMultiplesOfAdjustmentStep(unit: ConsumptionUnitType) {
        // tests if the bounds are on the ticks of the slider
        let tolerance = 0.001

        let lowerBoundQuotient = unit.consumptionRange.lowerBound / unit.adjustmentStep
        let upperBoundQuotient = unit.consumptionRange.upperBound / unit.adjustmentStep

        #expect(abs(lowerBoundQuotient - lowerBoundQuotient.rounded()) < tolerance)
        #expect(abs(upperBoundQuotient - upperBoundQuotient.rounded()) < tolerance)
    }

    @Test(arguments: ConsumptionUnitType.allCases)
    func consumptionRangeIsPlausible(unit: ConsumptionUnitType) {
        let plausibleRangeInKwhPer100km: ClosedRange<Double> = 10...35

        let lowerBoundInKwhPer100km = unit.toCanonical(unit.consumptionRange.lowerBound)
        let upperBoundInKwhPer100km = unit.toCanonical(unit.consumptionRange.upperBound)

        #expect(plausibleRangeInKwhPer100km.contains(lowerBoundInKwhPer100km))
        #expect(plausibleRangeInKwhPer100km.contains(upperBoundInKwhPer100km))
    }

    @Test(arguments: ConsumptionUnitType.allCases)
    func standardAvgConsumptionIsInRange(unit: ConsumptionUnitType) {
        #expect(unit.consumptionRange.contains(unit.standardAvgConsumption))
    }

    @Test(arguments: ConsumptionUnitType.allCases)
    func standardAvgConsumptionIsMultipleOfAdjustmentStep(unit: ConsumptionUnitType) {
        let tolerance = 0.001

        let quotient = unit.standardAvgConsumption / unit.adjustmentStep

        #expect(abs(quotient - quotient.rounded()) < tolerance)
    }
}

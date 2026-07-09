//
//  RangeBuddyTests.swift
//  RangeBuddyTests
//
//  Created by Stephan Weber on 04.07.26.
//

import Testing
@testable import RangeBuddy

struct RangeCalculatorTest {

    @Test func calculatesRangeFromKnownValues() {
        let result = RangeCalculator.rangeInKm(soc: 100,
                                               avgConsumption: 20,
                                               batteryCapacity: 50)
        #expect(result == 250)
    }

    @Test func calculatesRangeFromKnownDoubleValues() {
        let result = RangeCalculator.rangeInKm(soc: 50,
                                               avgConsumption: 17.5,
                                               batteryCapacity: 58)
        let expected = 165.714286
        let tolerance = 0.001
        #expect(abs(result - expected) < tolerance)
    }

    @Test func returnZeroIfConsumptionIsZero() {
        let result = RangeCalculator.rangeInKm(soc: 50,
                                               avgConsumption: 0,
                                               batteryCapacity: 50)
        #expect(result == 0)
    }

    @Test func returnZeroIfConsumptionIsNegative() {
        let result = RangeCalculator.rangeInKm(soc: 50,
                                               avgConsumption: -5.0,
                                               batteryCapacity: 50)
        #expect(result == 0)
    }

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

    @Test(arguments: [
        (300, DistanceUnit.km, 300),
        (300, DistanceUnit.mi, 186),
        (320, DistanceUnit.mi, 198)
    ])
    func displayDistanceReturnsKnownValue(fromKm: Double, unit: DistanceUnit, expected: Int) {
        #expect(unit.displayDistance(fromKm) == expected)
    }
}

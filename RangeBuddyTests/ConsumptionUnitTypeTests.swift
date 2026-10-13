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

}

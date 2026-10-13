//
//  RangeCalculatorTests.swift
//  RangeBuddyTests
//
//  Created by Stephan Weber on 10.10.26.
//

import Testing
@testable import RangeBuddy

struct RangeCalculatorTests {

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
}

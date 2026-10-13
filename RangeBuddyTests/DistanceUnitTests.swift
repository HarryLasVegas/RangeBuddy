//
//  DistanceUnitTests.swift
//  RangeBuddyTests
//
//  Created by Stephan Weber on 10.10.26.
//

import Testing
@testable import RangeBuddy

struct DistanceUnitTests {

    @Test(arguments: [
        (300, DistanceUnit.km, 300),
        (300, DistanceUnit.mi, 186),
        (320, DistanceUnit.mi, 198)
    ])
    func displayDistanceReturnsKnownValue(fromKm: Double, unit: DistanceUnit, expected: Int) {
        #expect(unit.displayDistance(fromKm) == expected)
    }
}

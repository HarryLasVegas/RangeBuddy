//
//  MatrixCalculator.swift
//  RangeBuddy
//
//  Created by Stephan Weber on 02.09.26.
//

import Foundation

nonisolated struct MatrixCalculator {
    private init() {}

    private static let rangeTolerance = 1e-9

    static func createMatrix(
        soc socAxisSpec: AxisSpec,
        avgConsumption avgConsumptionAxisSpec: AxisSpec,
        batteryCapacity: Double,
        matrixDimension: Int,
        consumptionUnitType: ConsumptionUnitType
    ) -> RangeMatrix {

        precondition(matrixDimension > 0 && matrixDimension % 2 != 0, "matrixDimension must be a positive, odd number")

        let socHeaders = createHeaderValues(
            axisSpec: socAxisSpec,
            matrixDimension: matrixDimension
        )

        var avgConsumptionHeaders = createHeaderValues(
            axisSpec: avgConsumptionAxisSpec,
            matrixDimension: matrixDimension
        )

        if consumptionUnitType.higherIsMoreEfficient {
            avgConsumptionHeaders.values.reverse()
            avgConsumptionHeaders.baseValueIndex = avgConsumptionHeaders.values.count
                                                    - avgConsumptionHeaders.baseValueIndex - 1
        }

        var values: [[Int]] = []
        let distanceUnit = consumptionUnitType.distanceUnit

        for consumption in avgConsumptionHeaders.values {
            var rangeRow: [Int] = []
            let canonicalConsumption = consumptionUnitType.toCanonical(consumption)

            for soc in socHeaders.values {
                let rangeInKm = RangeCalculator.rangeInKm(
                    soc: soc,
                    avgConsumption: canonicalConsumption,
                    batteryCapacity: batteryCapacity
                )

                rangeRow.append(distanceUnit.displayDistance(rangeInKm))
            }

            values.append(rangeRow)
        }

        return RangeMatrix(
            socHeaders: socHeaders.values,
            avgConsumptionHeaders: avgConsumptionHeaders.values,
            values: values,
            currentSocIndex: socHeaders.baseValueIndex,
            currentAvgConsumptionIndex: avgConsumptionHeaders.baseValueIndex,
            consumptionUnitType: consumptionUnitType
        )
    }

    private static func getValidStepsBelow(
        baseValue: Double,
        stepSize: Double,
        lowerBound: Double
    ) -> [Double] {
        var validSteps: [Double] = []

        var nextStep = baseValue - baseValue.truncatingRemainder(dividingBy: stepSize)
        if nextStep >= baseValue {
            nextStep -= stepSize
        }

        while nextStep >= lowerBound {
            validSteps.append(nextStep)
            nextStep -= stepSize
        }

        return validSteps.reversed()
    }

    private static func getValidStepsAbove(
        baseValue: Double,
        stepSize: Double,
        upperBound: Double
    ) -> [Double] {
        var validSteps: [Double] = []

        var nextStep = baseValue - baseValue.truncatingRemainder(dividingBy: stepSize) + stepSize

        while nextStep <= upperBound {
            validSteps.append(nextStep)
            nextStep += stepSize
        }

        return validSteps
    }

    private static func createHeaderValues(
        axisSpec: AxisSpec,
        matrixDimension: Int
    ) -> (values: [Double], baseValueIndex: Int) {

        let tolerantRange = (axisSpec.range.lowerBound - rangeTolerance)...(axisSpec.range.upperBound + rangeTolerance)

        precondition(
            tolerantRange.contains(axisSpec.currentValue),
            "The currentValue has to be in the given range with a small float tolerance"
        )
        precondition(axisSpec.range.contains(axisSpec.neighborLowerBound), "neighborLowerBound must be in given range")
        precondition(axisSpec.range.lowerBound >= 0, "Range must have only positive values")
        precondition(axisSpec.stepSize > 0, "StepSize has to be a positive number")

        // A neighbor that is displayed like the current value would show up as a duplicate row.
        let headerStyle: FloatingPointFormatStyle<Double> = .matrixHeader(maxFractionDigits: axisSpec.maxFractionDigits)
        let formattedBaseValue = axisSpec.currentValue.formatted(headerStyle)

        let candidatesBelowBase = getValidStepsBelow(
            baseValue: axisSpec.currentValue,
            stepSize: axisSpec.stepSize,
            lowerBound: axisSpec.neighborLowerBound
        ).filter {
            $0.formatted(headerStyle) != formattedBaseValue
        }

        let candidatesAboveBase = getValidStepsAbove(
            baseValue: axisSpec.currentValue,
            stepSize: axisSpec.stepSize,
            upperBound: axisSpec.range.upperBound
        ).filter {
            $0.formatted(headerStyle) != formattedBaseValue
        }

        precondition(
            candidatesBelowBase.count + candidatesAboveBase.count + 1 >= matrixDimension,
            "There must be at least matrixDimension values present"
        )

        var headerValues: [Double] = []

        let standardNumberOfValuesBelowAndAbove = (matrixDimension - 1) / 2
        let numberOfAdditionalBelowValues = standardNumberOfValuesBelowAndAbove - min(
            standardNumberOfValuesBelowAndAbove,
            candidatesAboveBase.count
        )

        let selectedValuesBelow = candidatesBelowBase.suffix(
            standardNumberOfValuesBelowAndAbove + numberOfAdditionalBelowValues
        )
        headerValues.append(contentsOf: selectedValuesBelow)

        let numberOfMaxAboveValues = matrixDimension - 1 - headerValues.count
        let selectedValuesAbove = candidatesAboveBase.prefix(numberOfMaxAboveValues)

        headerValues.append(axisSpec.currentValue)
        headerValues.append(contentsOf: selectedValuesAbove)

        let baseValueIndex = selectedValuesBelow.count

        return (headerValues, baseValueIndex)
    }
}

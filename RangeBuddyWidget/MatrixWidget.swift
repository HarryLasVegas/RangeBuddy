//
//  MatrixWidget.swift
//  RangeBuddyWidgetExtension
//
//  Created by Stephan Weber on 01.09.26.
//

import WidgetKit
import SwiftUI

struct MatrixWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> MatrixWidgetEntry {
        MatrixWidgetEntry(date: Date(), matrix: RangeMatrix.sampleMatrixDefault)
    }

    func getSnapshot(in context: Context, completion: @escaping (MatrixWidgetEntry) -> Void) {
        let entry = MatrixWidgetEntry(date: Date(), matrix: currentMatrix())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<MatrixWidgetEntry>) -> Void) {
        let entry = MatrixWidgetEntry(date: Date(), matrix: currentMatrix())

        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }

    private func currentMatrix() -> RangeMatrix {
        let store = DataStore()
        let socAxisSpec = AxisSpec(
            currentValue: store.soc,
            stepSize: AppConstants.matrixSocStepSize,
            range: AppConstants.socRange,
            neighborLowerBound: AppConstants.matrixSocStepSize,
            maxFractionDigits: AppConstants.matrixSocMaxFractionDigits
        )

        let consumptionUnitType = store.consumptionUnitType
        let consumptionRange = consumptionUnitType.consumptionRange

        let avgConsumptionAxisSpec = AxisSpec(
            currentValue: consumptionUnitType.fromCanonical(store.avgConsumptionInKwhPer100km),
            stepSize: consumptionUnitType.comparisonStep,
            range: consumptionRange,
            neighborLowerBound: consumptionRange.lowerBound,
            maxFractionDigits: consumptionUnitType.fractionDigits
        )

        return MatrixCalculator.createMatrix(
            soc: socAxisSpec,
            avgConsumption: avgConsumptionAxisSpec,
            batteryCapacity: store.batteryCapacity,
            matrixDimension: AppConstants.matrixDimension,
            consumptionUnitType: consumptionUnitType
        )
    }
}

struct MatrixWidgetEntry: TimelineEntry {
    let date: Date
    let matrix: RangeMatrix
}

struct MatrixWidgetEntryView: View {
    var entry: MatrixWidgetProvider.Entry
    private var matrix: RangeMatrix {
        entry.matrix
    }

    var body: some View {
        Grid(alignment: .trailing, horizontalSpacing: 4, verticalSpacing: 4) {
            GridRow {
                Color.clear
                    .gridCellUnsizedAxes([.horizontal, .vertical])

                ForEach(matrix.socHeaders.enumerated(), id: \.offset) { columnIndex, soc in
                    let isCurrentSoc = (columnIndex == matrix.currentSocIndex)

                    MatrixWidgetHeaderCellView(
                        headerValue: soc,
                        isHighlighted: isCurrentSoc,
                        fractionLength: 0...AppConstants.matrixSocMaxFractionDigits
                    )
                }
            }

            ForEach(matrix.avgConsumptionHeaders.enumerated(), id: \.offset) { rowIndex, consumption in
                let isCurrentAvgConsumption = (rowIndex == matrix.currentAvgConsumptionIndex)

                GridRow {

                    MatrixWidgetHeaderCellView(
                        headerValue: consumption,
                        isHighlighted: isCurrentAvgConsumption,
                        fractionLength: 0...matrix.consumptionUnitType.fractionDigits
                    )

                    ForEach(matrix.socHeaders.indices, id: \.self) { columnIndex in
                        let isCurrentCell = (isCurrentAvgConsumption &&
                                             columnIndex == matrix.currentSocIndex)

                        MatrixWidgetValueCellView(
                            value: matrix.range(
                                socIndex: columnIndex,
                                avgConsumptionIndex: rowIndex
                            ),
                            isHighlighted: isCurrentCell
                        )
                    }
                }
            }
        }
        .font(.system(size: 13))
        .monospacedDigit()
        .fontWidth(.condensed)
        .contentTransition(.numericText())
        .lineLimit(1)
        .minimumScaleFactor(0.5)
    }
}

struct MatrixWidget: Widget {
    let kind: String = AppConstants.matrixWidgetKind

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: MatrixWidgetProvider()) { entry in
            MatrixWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Range Matrix")
        .description("See how your range changes with SoC and consumption.")
        .supportedFamilies([.systemSmall])
        .contentMarginsDisabled()
    }
}

#Preview("Matrix5", as: .systemSmall) {
    MatrixWidget()
} timeline: {
    MatrixWidgetEntry(date: .now, matrix: RangeMatrix.sampleMatrix5)
}

#Preview("Worst Case", as: .systemSmall) {
    MatrixWidget()
} timeline: {
    MatrixWidgetEntry(date: .now, matrix: RangeMatrix.sampleMatrixWorstCase)
}

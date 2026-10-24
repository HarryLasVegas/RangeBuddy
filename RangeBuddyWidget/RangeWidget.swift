//
//  RangeWidget.swift
//  RangeBuddyWidgetExtension
//
//  Created by Stephan Weber on 10.09.26.
//

import WidgetKit
import SwiftUI

struct RangeWidgetProvider: TimelineProvider {
    func placeholder(in context: Context) -> RangeWidgetEntry {
        RangeWidgetEntry.placeholder
    }

    func getSnapshot(in context: Context, completion: @escaping (RangeWidgetEntry) -> Void) {
        let entry = createEntry()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<RangeWidgetEntry>) -> Void) {

        let entry = createEntry()

        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }

    private func createEntry() -> RangeWidgetEntry {
        let store = DataStore()

        let soc = store.soc
        let avgConsumptionInKwhPer100km = store.avgConsumptionInKwhPer100km
        let batteryCapacity = store.batteryCapacity
        let consumptionUnitType = store.consumptionUnitType
        let distanceUnit = consumptionUnitType.distanceUnit

        let rangeInKm = RangeCalculator.rangeInKm(
            soc: soc,
            avgConsumption: avgConsumptionInKwhPer100km,
            batteryCapacity: batteryCapacity
        )
        let range = distanceUnit.displayDistance(rangeInKm)

        let socSliceRangeInKm = RangeCalculator.rangeInKm(
            soc: AppConstants.rangeWidgetSocSlice,
            avgConsumption: avgConsumptionInKwhPer100km,
            batteryCapacity: batteryCapacity
        )
        let socSliceRange = distanceUnit.displayDistance(socSliceRangeInKm)

        let entry = RangeWidgetEntry(
            date: Date(),
            soc: soc,
            range: range,
            avgConsumption: consumptionUnitType.fromCanonical(avgConsumptionInKwhPer100km),
            consumptionUnitType: consumptionUnitType,
            socSliceRange: socSliceRange
        )

        return entry
    }
}

struct RangeWidgetEntry: TimelineEntry {
    let date: Date
    let soc: Double
    let range: Int
    let avgConsumption: Double
    let consumptionUnitType: ConsumptionUnitType
    let socSliceRange: Int
}

extension RangeWidgetEntry {
    static let placeholder = RangeWidgetEntry(
        date: Date(),
        soc: 50.0,
        range: 165,
        avgConsumption: 17.5,
        consumptionUnitType: .kWhPer100km,
        socSliceRange: 33
    )
}

struct RangeWidgetEntryView: View {
    var entry: RangeWidgetProvider.Entry

    var body: some View {
        VStack(alignment: .leading) {
            VStack(spacing: 1) {
                HStack {
                    Text("SoC")
                    Spacer()
                    Text("Avg Cons")
                }
                .fontWeight(.semibold)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .textCase(.uppercase)

                HStack {
                    HStack(spacing: 5) {
                        SocRingView(soc: entry.soc)

                        Text(entry.soc.formatted(
                            .number.precision(.fractionLength(0...AppConstants.widgetSocMaxFractionDigits))) + "%")
                    }

                    Spacer()

                    Text(
                        entry.avgConsumption.formatted(
                            .number.precision(
                                .fractionLength(0...entry.consumptionUnitType.fractionDigits)
                            )
                        )
                    )

                }
                .font(.body)
                .fontWeight(.bold)
                .fontWidth(.condensed)
            }

            Spacer()
            Spacer()

            VStack(alignment: .leading, spacing: 0) {
                Text("Range")
                    .fontWeight(.semibold)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)

                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Text(entry.range.formatted())
                        .font(.largeTitle.bold())
                        .padding(.top, -5)
                        .foregroundStyle(.teal)
                        .monospacedDigit()

                    Text(entry.consumptionUnitType.distanceUnit.shortLabel)
                        .font(.caption2)
                }
                .fontWidth(.condensed)
            }
            .frame(maxWidth: .infinity, alignment: .bottomLeading)

            Spacer()

            Divider()

            HStack(alignment: .lastTextBaseline) {
                HStack(spacing: 2) {
                    Text(AppConstants.rangeWidgetSocSlice.formatted(.number.precision(.fractionLength(0...1))) + "%")
                    Text("SoC")
                        .textCase(.uppercase)
                    Image(systemName: "arrow.left.arrow.right")
                        .imageScale(.small)
                }
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)

                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Text(entry.socSliceRange.formatted())
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundStyle(.teal)

                    Text(entry.consumptionUnitType.distanceUnit.shortLabel)
                }
                .fontWidth(.condensed)
            }
            .frame(maxWidth: .infinity, alignment: .bottomLeading)
            .font(.caption2)
        }
        .padding()
        .contentTransition(.numericText())
        .minimumScaleFactor(0.5)
        .dynamicTypeSize(...DynamicTypeSize.xLarge)
    }
}

struct RangeWidget: Widget {
    let kind: String = AppConstants.rangeWidgetKind

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: RangeWidgetProvider()) { entry in
            RangeWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Remaining Range")
        .description("Your remaining range at a glance.")
        .supportedFamilies([.systemSmall])
        // CarPlay drops the content margins, so the view adds its own padding
        .contentMarginsDisabled()
    }

}

#Preview(as: .systemSmall) {
    RangeWidget()
} timeline: {
    RangeWidgetEntry.placeholder
}

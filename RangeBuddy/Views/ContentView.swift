//
//  ContentView.swift
//  RangeBuddy
//
//  Created by Stephan Weber on 15.06.26.
//

import SwiftUI
import AppIntents
import WidgetKit

struct ContentView: View {
    @AppStorage(AppStorageKeys.soc.rawValue, store: .shared)
    private var soc: Double = AppConstants.standardSoc

    @AppStorage(AppStorageKeys.avgConsumptionInKwhPer100km.rawValue, store: .shared)
    private var avgConsumptionInKwhPer100km: Double = AppConstants.standardAvgConsumptionInKwhPer100km

    @AppStorage(AppStorageKeys.batteryCapacity.rawValue, store: .shared)
    private var batteryCapacity: Double = AppConstants.standardBatteryCapacity

    @AppStorage(AppStorageKeys.consumptionUnitType.rawValue, store: .shared)
    private var consumptionUnitType: ConsumptionUnitType = AppConstants.consumptionUnitType

    @AppStorage(AppStorageKeys.siriTipsAreVisible.rawValue, store: .shared)
    private var siriTipsAreVisible: Bool = true

    @AppStorage(AppStorageKeys.hasCompletedOnboarding.rawValue, store: .shared)
    private var hasCompletedOnboarding: Bool = false

    @State
    private var settingsSheetIsShown: Bool = false

    @Environment(\.scenePhase)
    private var scenePhase

    var body: some View {
        NavigationStack {
            Form {
                Section("Remaining Range") {
                    VStack(spacing: 4) {
                        HStack(alignment: .firstTextBaseline) {
                            Text("\(range)")
                                .font(.system(size: 100, weight: .bold, design: .rounded))
                                .animation(.default, value: range)
                                .contentTransition(.numericText())
                                .minimumScaleFactor(0.5)
                            Text(consumptionUnitType.distanceUnit.shortLabel)
                                .foregroundStyle(.secondary)
                                .font(.footnote)
                        }
                        SiriTipView(intent: GetRangeIntent(), isVisible: $siriTipsAreVisible)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                }

                Section("SoC") {
                    VStack {
                        HStack {
                            Slider(value: $soc, in: AppConstants.socRange, step: 1)
                            Spacer(minLength: 20)
                            Text(formattedSoc + "%")
                                .fontDesign(.monospaced)
                                .animation(.default, value: soc)
                                .contentTransition(.numericText())
                        }
                        SiriTipView(intent: SetSoCIntent(), isVisible: $siriTipsAreVisible)
                    }
                }

                Section("Average Consumption") {
                    VStack {
                        Group {
                            HStack {
                                Slider(
                                    value: Binding(
                                        get: { consumptionUnitType.fromCanonical(avgConsumptionInKwhPer100km)},
                                        set: { displayValue in
                                            avgConsumptionInKwhPer100km = consumptionUnitType.toCanonical(displayValue)
                                        }),
                                    in: consumptionUnitType.consumptionRange,
                                    step: consumptionUnitType.adjustmentStep
                                )
                                Spacer(minLength: 20)
                                Text(formattedConsumption)
                                    .contentTransition(.numericText())
                            }

                            HStack {
                                Spacer()
                                Text(consumptionUnitType.shortLabel)
                                    .font(.footnote)
                            }
                        }
                        .fontDesign(.monospaced)
                        .animation(.default, value: avgConsumptionInKwhPer100km)
                        .contentTransition(.numericText())

                        SiriTipView(intent: SetConsumptionIntent(), isVisible: $siriTipsAreVisible)
                    }
                }

                if siriTipsAreVisible {
                    Section("Set both at once") {
                        SiriTipView(intent: SetSocAndConsumptionIntent(), isVisible: $siriTipsAreVisible)
                    }
                }

            }
            .tint(.teal)
            .navigationTitle("RangeBuddy")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        settingsSheetIsShown = true
                    } label: {
                        Label("Settings", systemImage: "gear")
                    }
                }
            }
            .sheet(isPresented: $settingsSheetIsShown) {
                SettingsView()
            }
            .fullScreenCover(isPresented: $hasCompletedOnboarding.inverted) {
                OnboardingView()
            }
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .inactive || newPhase == .background {
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
    }
}

extension ContentView {
    private var range: Int {
        let rangeInKm = RangeCalculator.rangeInKm(
            soc: soc,
            avgConsumption: avgConsumptionInKwhPer100km,
            batteryCapacity: batteryCapacity
        )

        return consumptionUnitType.distanceUnit.displayDistance(rangeInKm)
    }

    private var formattedConsumption: String {
        consumptionUnitType.fromCanonical(avgConsumptionInKwhPer100km)
            .formatted(.number.precision(.fractionLength(
                consumptionUnitType.fractionDigits...AppConstants.socAndConsumptionMaxFractionDigits)))
    }

    private var formattedSoc: String {
        soc.formatted(.number.precision(.fractionLength(0...AppConstants.socAndConsumptionMaxFractionDigits)))
    }
}

#Preview {
    ContentView()
}

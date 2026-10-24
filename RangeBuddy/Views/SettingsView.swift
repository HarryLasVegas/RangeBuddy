//
//  SettingsView.swift
//  RangeBuddy
//
//  Created by Stephan Weber on 24.06.26.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage(AppStorageKeys.siriTipsAreVisible.rawValue, store: .shared)
    private var siriTipsAreVisible = true

    @AppStorage(AppStorageKeys.batteryCapacity.rawValue, store: .shared)
    private var batteryCapacity: Double = AppConstants.standardBatteryCapacity

    @AppStorage(AppStorageKeys.consumptionUnitType.rawValue, store: .shared)
    private var consumptionUnitType: ConsumptionUnitType = AppConstants.consumptionUnitType

    @AppStorage(AppStorageKeys.avgConsumptionInKwhPer100km.rawValue, store: .shared)
    private var avgConsumptionInKwhPer100km: Double = AppConstants.standardAvgConsumptionInKwhPer100km

    @Environment(\.dismiss)
    private var dismiss

    private let email = "info@harrylasvegas.de"

    #if DEBUG
    @AppStorage(AppStorageKeys.hasCompletedOnboarding.rawValue, store: .shared)
    private var hasCompletedOnboarding: Bool = false
    #endif

    var body: some View {
        NavigationStack {
            Form {
                Section("Battery Capacity") {
                    HStack {
                        Slider(value: $batteryCapacity, in: AppConstants.batteryCapacityRange, step: 1)
                        Spacer(minLength: 20)
                        Text("\(batteryCapacity, format: .number.precision(.fractionLength(0)))kWh")
                            .fontDesign(.monospaced)
                            .animation(.default, value: batteryCapacity)
                            .contentTransition(.numericText())
                    }
                }

                Section("Consumption Unit") {
                    Picker("Select Unit", selection: $consumptionUnitType) {
                        ForEach(ConsumptionUnitType.allCases) { type in
                            Text(type.shortLabel).tag(type)
                        }
                    }
                    .pickerStyle(.menu)
                }

                Section("Siri Tips") {
                    Toggle("Show Siri tips", isOn: $siriTipsAreVisible)
                }

                #if DEBUG
                Section {
                    Toggle(isOn: $hasCompletedOnboarding) {
                        Text(verbatim: "Completed")
                    }
                } header: {
                    Text(verbatim: "OnBoarding")
                }
                #endif

                Section("About") {
                    LabeledContent("Version") {
                        Text(verbatim: Bundle.main.fullVersionDescription)
                    }
                    LabeledContent("Author") {
                        Text(verbatim: "Stephan Weber")
                    }
                    LabeledContent("Mail") {
                        Link(destination: URL(string: "mailto:\(email)")!) {
                            Text(verbatim: email)
                        }
                    }
                    LabeledContent("License") {
                        Text(verbatim: "Open Source - MIT")
                    }
                }
                .listSectionSpacing(50)
            }
            .tint(.teal)
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(role: .close) {
                        dismiss()
                    }
                }
            }
        }
        .onChange(of: consumptionUnitType) { _, newValue in
            // Resets the consumption to the standard value of the new unit, so the slider
            // starts on a clean step instead of a converted, crooked value.
            // This is the only place where the unit changes. Any future way to change it
            // (e.g. an intent) must reset the consumption the same way.
            avgConsumptionInKwhPer100km = newValue.toCanonical(newValue.standardAvgConsumption)
        }
    }
}

#Preview {
    SettingsView()
}

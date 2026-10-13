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
                            Text(type.fullUnitString).tag(type)
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
    }
}

#Preview {
    SettingsView()
}

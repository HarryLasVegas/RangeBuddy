//
//  RangeShortcuts.swift
//  RangeBuddy
//
//  Created by Stephan Weber on 17.06.26.
//

import AppIntents

struct RangeShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: GetRangeIntent(),
            phrases: [
                "\(.applicationName) get range",
                "\(.applicationName) range",
                "\(.applicationName) what's my range",
                "\(.applicationName) what's my remaining range"
            ],
            shortTitle: "Get Range",
            systemImageName: "car.rear.road.lane.dashed"
        )

        AppShortcut(
            intent: SetSoCIntent(),
            phrases: [
                "\(.applicationName) set SoC",
                "\(.applicationName) set state of charge",
                "\(.applicationName) change SoC",
                "\(.applicationName) change state of charge"
            ],
            shortTitle: "Set SoC",
            systemImageName: "battery.75percent"
        )

        AppShortcut(
            intent: SetConsumptionIntent(),
            phrases: [
                "\(.applicationName) set consumption",
                "\(.applicationName) set average consumption",
                "\(.applicationName) change consumption",
                "\(.applicationName) change average consumption"
            ],
            shortTitle: "Set Consumption",
            systemImageName: "bolt.car"
        )

        AppShortcut(
            intent: SetSocAndConsumptionIntent(),
            phrases: [
                "\(.applicationName) set SoC and consumption",
                "\(.applicationName) set SoC and average consumption",
                "\(.applicationName) set state of charge and consumption",
                "\(.applicationName) set state of charge and average consumption",
                "\(.applicationName) change SoC and consumption",
                "\(.applicationName) change SoC and average consumption",
                "\(.applicationName) change state of charge and consumption",
                "\(.applicationName) change state of charge and average consumption"
            ],
            shortTitle: "Set SoC and Consumption",
            systemImageName: "bolt.car.fill"
        )
    }
}

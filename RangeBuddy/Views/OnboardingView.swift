//
//  OnboardingView.swift
//  RangeBuddy
//
//  Created by Stephan Weber on 29.06.26.
//

import SwiftUI
import AppIntents

struct OnboardingView: View {
    @AppStorage(AppStorageKeys.hasCompletedOnboarding.rawValue, store: .shared)
    private var hasCompletedOnboarding: Bool = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image("AppIconPng")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)

                claimView
                siriTipsView
                notesView
            }
        }
        .padding()
        .safeAreaInset(edge: .bottom) {
            Button("Get started!") { hasCompletedOnboarding = true }
                .buttonStyle(.glassProminent)
                .buttonSizing(.flexible)
                .controlSize(.extraLarge)
                .padding([.leading, .trailing, .bottom])
        }
    }
}

extension OnboardingView {

    private var claimView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Tired of your EV guessing your range wrong?")
                .font(.title3).bold()
            Text("Let RangeBuddy work it out from your real consumption - and just ask Siri while you drive.")
                .foregroundStyle(.secondary)
        }
    }

    private var siriTipsView: some View {
        GroupBox(label:
                    Text("Try")
                        .foregroundStyle(.teal)
                        .fontWeight(.bold)
                        .textCase(.uppercase)
        ) {
            SiriTipView(intent: SetSoCIntent())
            SiriTipView(intent: SetConsumptionIntent())
            SiriTipView(intent: SetSocAndConsumptionIntent())
            SiriTipView(intent: GetRangeIntent())
        }
    }

    private var notesView: some View {
        GroupBox(label:
                    Text("Please note")
                        .foregroundStyle(.teal)
                        .fontWeight(.bold)
                        .textCase(.uppercase)
        ) {
            BulletRowView(iconString: "info.circle",
                          text: """
                                RangeBuddy can't access your car's data (like the current charge). \
                                You enter all values yourself.
                                """)

            BulletRowView(iconString: "info.circle",
                          text: """
                                Siri only accepts whole numbers for now.
                                """)

            BulletRowView(iconString: "info.circle",
                          text: """
                                Siri reserves words like 'battery' for your iPhone's own battery - \
                                say 'SoC' or 'charge percentage' instead.
                                """)
        }
    }
}

#Preview {
    OnboardingView()
}

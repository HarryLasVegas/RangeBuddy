//
//  SocRingView.swift
//  RangeBuddy
//
//  Created by Stephan Weber on 07.10.26.
//

import SwiftUI

struct SocRingView: View {
    @ScaledMetric(relativeTo: .body) private var ringSize: CGFloat = 17

    let soc: Double
    private let lineWidth: CGFloat = 2

    var body: some View {
        ZStack {
            Circle()
                .inset(by: lineWidth / 2)
                .stroke(lineWidth: lineWidth)
                .foregroundStyle(.tertiary)

            Circle()
                .inset(by: lineWidth / 2)
                .trim(from: 0, to: soc / 100)
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
        .frame(width: ringSize, height: ringSize)
    }
}

#Preview {
    HStack {
        SocRingView(soc: 0)
        SocRingView(soc: 33)
        SocRingView(soc: 100)
    }
}

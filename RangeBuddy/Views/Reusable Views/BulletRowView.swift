//
//  BulletRowView.swift
//  RangeBuddy
//
//  Created by Stephan Weber on 04.07.26.
//

import SwiftUI

struct BulletRowView: View {
    let iconString: String
    let text: LocalizedStringKey

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
                Image(systemName: iconString)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20)
                    .padding(.trailing)
                    .foregroundStyle(.teal)
                Text(text)
                    .font(.footnote)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
    }
}

#Preview {
    BulletRowView(iconString: "info.circle",
                  text: """
                        RangeBuddy can't access your car's data (like the SoC). \
                        You have to provide all data by yourself.
                        """)
}

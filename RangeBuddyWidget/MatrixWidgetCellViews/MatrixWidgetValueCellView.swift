//
//  MatrixWidgetValueCellView.swift
//  RangeBuddy
//
//  Created by Stephan Weber on 01.10.26.
//

import SwiftUI

struct MatrixWidgetValueCellView: View {
    let value: Int
    let isHighlighted: Bool

    var body: some View {
        Text(value.formatted(.number))
            .fontWidth(value >= 1_000 ? .compressed : .condensed)
            .fontWeight(isHighlighted ? .bold : .light)
            .foregroundStyle(isHighlighted ? .teal : .primary)
    }
}

#Preview {
    MatrixWidgetValueCellView(value: 1110, isHighlighted: true)
}

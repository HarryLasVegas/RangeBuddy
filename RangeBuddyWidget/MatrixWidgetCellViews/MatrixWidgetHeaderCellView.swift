//
//  MatrixWidgetHeaderCellView.swift
//  RangeBuddy
//
//  Created by Stephan Weber on 01.10.26.
//

import SwiftUI

struct MatrixWidgetHeaderCellView: View {
    let headerValue: Double
    let isHighlighted: Bool
    let fractionLength: ClosedRange<Int>

    private var formattedValue: AttributedString {
        var attributed = headerValue.formatted(
            .number.precision(.fractionLength(fractionLength))
            .attributed)

        for run in attributed.runs {
            if run.attributes.numberPart == .fraction ||
                run.attributes.numberSymbol == .decimalSeparator {
                attributed[run.range].font = .system(size: 8)
                attributed[run.range].kern = -2
            }
        }
        return attributed
    }

    var body: some View {
        Text(formattedValue)
            .fontWeight(.black)
            .foregroundStyle(isHighlighted ? .teal : .primary)
    }
}

#Preview {
    MatrixWidgetHeaderCellView(
        headerValue: 17.5,
        isHighlighted: true,
        fractionLength: 0...AppConstants.matrixSocMaxFractionDigits
    )
}

//
//  FormatStyle+Ext.swift
//  RangeBuddy
//
//  Created by Stephan Weber on 23.10.26.
//

import Foundation

nonisolated
extension FormatStyle where Self == FloatingPointFormatStyle<Double> {
    static func matrixHeader(maxFractionDigits: Int) -> Self {
        return Self.number.precision(.fractionLength(0...maxFractionDigits))
    }
}

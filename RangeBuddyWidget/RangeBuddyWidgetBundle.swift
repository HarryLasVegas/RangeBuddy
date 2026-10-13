//
//  RangeBuddyWidgetBundle.swift
//  RangeBuddyWidget
//
//  Created by Stephan Weber on 31.08.26.
//

import WidgetKit
import SwiftUI

@main
struct RangeBuddyWidgetBundle: WidgetBundle {
    var body: some Widget {
        MatrixWidget()
        RangeWidget()
    }
}

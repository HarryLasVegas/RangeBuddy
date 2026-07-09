//
//  Bool+Ext.swift
//  RangeBuddy
//
//  Created by Stephan Weber on 29.06.26.
//

extension Bool {
    /// A read/write inverse, usable as a two-way `Binding`.
    ///
    /// The setter is required: a get-only property has no writable key path,
    /// so `$flag.inverted` could not project a `Binding`.
    ///
    /// Used here e.g.: `.fullScreenCover(isPresented: $hasCompletedOnboarding.inverted)`
    var inverted: Self {
        get { !self }
        set { self = !newValue }
    }
}

//
//  OffsetKey.swift
//  FitnessApp
//
//  Created by Robert Basamac on 10.08.2023.
//

import SwiftUI

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct OffseMonthtKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

//struct TabViewHeightPreference: PreferenceKey {
//    static var defaultValue: CGFloat = 0
//    
//    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
//        value = max(value, nextValue())
//    }
//}

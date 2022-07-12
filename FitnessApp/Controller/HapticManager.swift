//
//  HapticManager.swift
//  FitnessApp
//
//  Created by Robert Basamac on 12.07.2022.
//

import SwiftUI

class HapticManager {
    
    static let instante = HapticManager()
    
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}

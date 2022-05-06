//
//  Set.swift
//  FitnessApp
//
//  Created by Robert Basamac on 05.05.2022.
//

import Foundation

class Set: Identifiable {
    var id: String = UUID().uuidString
    var reps: Int?
    var duration: Int?
    var weight: Float
    
    init(reps: Int, weight: Float) {
        self.reps = reps
        self.weight = weight
    }
    
    init(duration: Int, weight: Float) {
        self.duration = duration
        self.weight = weight
    }
}

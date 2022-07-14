//
//  Set.swift
//  FitnessApp
//
//  Created by Robert Basamac on 07.05.2022.
//

import Foundation

struct Set: Hashable {
    var weight: Float = 0
    var duration: Int = 1
    var rest: Int = 0
    var reps: Int = 1
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(weight + Float(duration) + Float(rest) + Float(reps))
    }
}

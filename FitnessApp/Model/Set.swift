//
//  Set.swift
//  FitnessApp
//
//  Created by Robert Basamac on 07.05.2022.
//

import Foundation

struct Set: Identifiable, Equatable {
    var id: UUID = UUID()
    var weight: Float = 0
    var duration: Int = 1
    var rest: Int = 0
    var reps: Int = 1
}

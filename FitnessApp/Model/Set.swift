//
//  Set.swift
//  FitnessApp
//
//  Created by Robert Basamac on 07.05.2022.
//

import Foundation

struct Set: Identifiable {
    var id: String = UUID().uuidString
    var weight: Float
    var reps: Int
}

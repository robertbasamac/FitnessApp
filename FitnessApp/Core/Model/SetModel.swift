//
//  Set.swift
//  FitnessApp
//
//  Created by Robert Basamac on 07.05.2022.
//

import Foundation

struct SetModel: Identifiable, Hashable {
    var id: String = UUID().uuidString
    var weight: Double = 0
    var duration: Int = 1
    var rest: Int = 0
    var reps: Int = 1
}

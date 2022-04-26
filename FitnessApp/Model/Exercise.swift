//
//  Exercise.swift
//  FitnessApp
//
//  Created by Robert Basamac on 21.04.2022.
//

import Foundation

struct Exercise: Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var type: ExerciseType
    var numberOfSets: Int
    var weight: Int
}

enum ExerciseType {
    case timeBased
    case repBased
}

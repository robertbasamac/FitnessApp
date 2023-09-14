//
//  Workout.swift
//  FitnessApp
//
//  Created by Robert Basamac on 21.04.2022.
//

import Foundation

struct WorkoutModel: Identifiable, Hashable {
    var id: String = UUID().uuidString
    var title: String = ""
    var details: String = ""
    var exercises: [ExerciseModel] = []
}

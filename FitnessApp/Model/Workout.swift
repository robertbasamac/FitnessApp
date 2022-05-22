//
//  Workout.swift
//  FitnessApp
//
//  Created by Robert Basamac on 21.04.2022.
//

import Foundation

struct Workout: Identifiable {
    var id: String = UUID().uuidString
    var title: String = ""
    var description: String = ""
//    var pauseBetweenExercises: Int = 0
    var exercises: [Exercise] = []
}

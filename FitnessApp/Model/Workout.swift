//
//  Workout.swift
//  FitnessApp
//
//  Created by Robert Basamac on 21.04.2022.
//

import Foundation

class Workout: Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var description: String?
    var recoveryTimeBetweenExercises: Int
    var exercises: [Exercise]
    
    init(title: String, description: String, recoveryTimeBetweenExercises: Int, exercises: [Exercise]) {
        self.title = title
        self.description = description
        self.recoveryTimeBetweenExercises = recoveryTimeBetweenExercises
        self.exercises = exercises
    }
    
    init(title: String, recoveryTimeBetweenExercises: Int, exercises: [Exercise]) {
        self.title = title
        self.recoveryTimeBetweenExercises = recoveryTimeBetweenExercises
        self.exercises = exercises
    }
}

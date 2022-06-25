//
//  Workout.swift
//  FitnessApp
//
//  Created by Robert Basamac on 21.04.2022.
//

import Foundation

struct Workout: Identifiable, Equatable {
    var id: UUID = UUID()
    var title: String = ""
    var description: String = ""
    var exercises: [Exercise] = [Exercise()]
    
    init(id: UUID = UUID(), title: String = "", description: String = "", exercises: [Exercise] = [Exercise()]) {
        self.title = title
        self.description = description
        self.exercises = exercises
    }
    
    init(workout: Workout) {
        self.id = UUID()
        self.title = workout.title
        self.description = workout.description
        self.exercises = workout.exercises
    }
}

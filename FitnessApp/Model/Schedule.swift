//
//  Schedule.swift
//  FitnessApp
//
//  Created by Robert Basamac on 21.04.2022.
//

import Foundation

struct Schedule: Identifiable {
    var id: String = UUID().uuidString
    var workoutList: (date: Date, workouts: [Workout])
}

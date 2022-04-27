//
//  WorkoutManager.swift
//  FitnessApp
//
//  Created by Robert Basamac on 27.04.2022.
//

import Foundation

class WorkoutManager: ObservableObject {
    @Published var schedule = [
        Date(): [Workout(title: "Bench press"), Workout(title: "Leg press")],
        Date(): [Workout(title: "Shoulder press"), Workout(title: "Abs")]
        ]
    
    func hasWorkouts(for day: Date) -> Bool {
        return schedule.keys.contains { date in
            Calendar.autoupdatingCurrent.isDate(date, inSameDayAs: day)
        }
    }
    
    func add(workout: Workout, for day: Date) {
        schedule.updateValue([workout], forKey: day)
    }
}

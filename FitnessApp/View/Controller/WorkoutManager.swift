//
//  WorkoutManager.swift
//  FitnessApp
//
//  Created by Robert Basamac on 27.04.2022.
//

import Foundation

class WorkoutManager: ObservableObject {
    @Published var schedule: [String: [Workout]] = [
        "05/05/2022": [Workout(title: "Upper body", description: "Workout the entire upper body", exercises: [Exercise(title: "Bench press", type: .repBased, sets: [Set(weight: 5, reps: 10)])])]
//        "02/05/2022": [Workout(title: "Bench press"), Workout(title: "Leg press")],
//        "04/05/2022": [Workout(title: "Bench press"), Workout(title: "Leg press"), Workout(title: "Leg press"), Workout(title: "Leg press"), Workout(title: "Leg press"), Workout(title: "Leg press"), Workout(title: "Leg press"), Workout(title: "Leg press"), Workout(title: "Leg press"), Workout(title: "Leg press"), Workout(title: "Leg press"), Workout(title: "Leg press"), Workout(title: "Leg press"), Workout(title: "Leg press"), Workout(title: "Leg press"), Workout(title: "Leg press"), Workout(title: "Leg press"), Workout(title: "Leg press"), Workout(title: "Leg press"), Workout(title: "Leg press"), Workout(title: "Leg press"), Workout(title: "Leg press"), Workout(title: "Leg press"), Workout(title: "Leg press"), Workout(title: "Leg press"), Workout(title: "Leg press"), Workout(title: "Leg press"), Workout(title: "Leg press"), Workout(title: "Leg press"), Workout(title: "Leg press"), Workout(title: "Leg press"), Workout(title: "Leg press"), Workout(title: "Leg press"), Workout(title: "Leg press"), Workout(title: "Leg press"), Workout(title: "Leg press"), Workout(title: "Leg press"), Workout(title: "Leg press")],
//        "05/05/2022": [Workout(title: "Bench press"), Workout(title: "Leg press")],
//        "07/05/2022": [Workout(title: "Bench press"), Workout(title: "Leg press")],
//        "08/05/2022": [Workout(title: "Shoulder press"), Workout(title: "Abs")]
        ]
    
    @Published var workouts: [Workout] = [Workout(title: "Upper body", description: "Workout the entire upper body", exercises: [Exercise(title: "Bench press", type: .repBased, sets: [Set(weight: 5, reps: 10)])])]
    
    func hasWorkouts(for day: String) -> Bool {
        return schedule.keys.contains(day)
    }
    
    func addWorkout(_ workout: Workout, for day: String) {
        if var mergedWorkouts = schedule[day] {
            mergedWorkouts.append(workout)
            schedule.updateValue(mergedWorkouts, forKey: day)
        } else {
            schedule.updateValue([workout], forKey: day)
        }
    }
    
    func getWorkouts(for day: String) -> [Workout]? {
        return schedule[day]
    }
}

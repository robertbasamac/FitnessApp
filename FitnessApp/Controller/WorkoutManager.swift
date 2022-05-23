//
//  WorkoutManager.swift
//  FitnessApp
//
//  Created by Robert Basamac on 27.04.2022.
//

import Foundation

class WorkoutManager: ObservableObject {
    @Published var schedule: [String: [Workout]] = [
        "23/05/2022": [Workout(title: "Upper body", description: "Workout the entire upper body", exercises: [Exercise(title: "Bench press", type: .repBased, sets: [Set(weight: 5, reps: 10)])])]
        ]
    
    @Published var workouts: [Workout] = [Workout(title: "Upper body", description: "Workout the entire upper body", exercises: [Exercise(title: "Bench press", type: .repBased, sets: [Set(weight: 5, reps: 10)])])]
    
    func hasWorkouts(for day: String) -> Bool {
        return schedule.keys.contains(day)
    }
    
    func assignWorkout(_ workout: Workout, for day: String) {
        if var mergedWorkouts = schedule[day] {
            mergedWorkouts.append(workout)
            schedule.updateValue(mergedWorkouts, forKey: day)
        } else {
            schedule.updateValue([workout], forKey: day)
        }
    }
    
    func addWorkoutToCollection(_ workout: Workout) {
        workouts.append(workout)
    }
    
    func getWorkouts(for day: String) -> [Workout]? {
        return schedule[day]
    }
    
    func getAllWorkoutsFromCollection() -> [Workout] {
        return workouts
    }
    
    func getAllWorkouts() -> [Workout?] {
        if workouts.count > 0 {
            return workouts
        }
        else {
            return []
        }
    }
    
    func removeWorkoutFromCollection(_ workout: Workout) {
        workouts.removeAll(where: { $0.id == workout.id } )
    }
    
    func updateWorkout(_ workout: Workout) {
        if let index = workouts.firstIndex(where: { $0.id == workout.id } ) {
            workouts[index] = workout
        }
    }
}

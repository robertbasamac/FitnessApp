//
//  WorkoutManager.swift
//  FitnessApp
//
//  Created by Robert Basamac on 27.04.2022.
//

import Foundation

class WorkoutManager: ObservableObject {
    @Published var schedule: [String: [UUID]] = [:]
    
    @Published var workouts: [Workout] = [
        Workout(title: "Upper body",
                description: "Workout the entire upper body",
                exercises: [
                    Exercise(title: "Bench press",
                             type: .repBased,
                             sets: [
                                Set(weight: 5, reps: 10)
                             ])
                ]),
        Workout(title: "Legs day",
                description: "Workout legs like hell. Multiple exercises with multiple sets.",
                exercises: [
                    Exercise(title: "Leg press",
                             type: .repBased,
                             sets: [
                                Set(weight: 5, reps: 10),
                                Set(weight: 10, reps: 8),
                                Set(weight: 15, reps: 5)
                             ]),
                    Exercise(title: "Lunges",
                             type: .repBased,
                             sets: [
                                Set(weight: 10, reps: 10),
                                Set(weight: 10, reps: 10),
                                Set(weight: 10, reps: 10)
                             ])
                ])
    ]
    
    //MARK: - Handle Workout Schedule
    func hasWorkouts(for day: String) -> Bool {
        return schedule.keys.contains(day)
    }
    
    func assignWorkout(_ workout: Workout, for day: String) {
        if var mergedWorkouts = schedule[day] {
            mergedWorkouts.append(workout.id)
            schedule.updateValue(mergedWorkouts, forKey: day)
        } else {
            schedule.updateValue([workout.id], forKey: day)
        }
    }
    
    func getWorkouts(for day: String) -> [Workout]? {
        if let workoutIDs = schedule[day] {
            var result: [Workout] = []
            
            for workout in self.workouts {
                if workoutIDs.contains(workout.id) {
                    result.append(workout)
                }
            }
            
            return result
        }
        
        return nil
    }
    
    //MARK: - Handle Workout Collection
    func addWorkoutToCollection(_ workout: Workout) {
        workouts.append(workout)
    }
    
    func removeWorkoutFromCollection(_ workout: Workout) {
        for key in schedule.keys {
            print(key)
            if var values = schedule[key] {
                print(values)
                values.removeAll(where: { $0 == workout.id } )
                schedule.updateValue(values, forKey: key)
                
                if values.count == 0 {
                    schedule.removeValue(forKey: key)
                }
            }
        }
        
        workouts.removeAll(where: { $0.id == workout.id } )
    }
    
    func updateWorkout(_ workout: Workout) {
        if let index = workouts.firstIndex(where: { $0.id == workout.id } ) {
            workouts[index] = workout
        }
    }
    
    func getAllWorkouts() -> [Workout?] {
        if workouts.count > 0 {
            return workouts
        }
        else {
            return []
        }
    }
    
    func getAllWorkoutsFromCollection() -> [Workout] {
        return workouts
    }
}

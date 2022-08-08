//
//  WorkoutManager.swift
//  FitnessApp
//
//  Created by Robert Basamac on 27.04.2022.
//

import Foundation

class WorkoutManager: ObservableObject {
    @Published var schedule: [String: [String]] = [:]
    
    @Published var workouts: [Workout] = [
        Workout(title: "Upper body",
                details: "Workout the entire upper body",
                exercises: [
                    Exercise(title: "Bench press",
                             type: .repBased,
                             sets: [
                                Set(weight: 5, reps: 10)
                             ])
                ]),
        Workout(title: "Legs day",
                details: "Workout legs like hell. Multiple exercises with multiple sets.",
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
                             ]),
                    Exercise(title: "Single Leg Squats",
                             type: .repBased,
                             sets: [
                                Set(weight: 5, reps: 10),
                                Set(weight: 10, reps: 8),
                                Set(weight: 20, reps: 5)
                             ]),
                    Exercise(title: "Bulgarian Deadlifts",
                             type: .repBased,
                             sets: [
                                Set(weight: 10, reps: 10),
                                Set(weight: 30, reps: 10),
                                Set(weight: 50, reps: 10)
                             ]),
                    Exercise(title: "Deadlift",
                             type: .repBased,
                             sets: [
                                Set(weight: 10, reps: 10),
                                Set(weight: 20, reps: 8),
                                Set(weight: 35, reps: 5)
                             ]),
                    Exercise(title: "Reverse Lunges",
                             type: .repBased,
                             sets: [
                                Set(weight: 10, reps: 10),
                                Set(weight: 10, reps: 10),
                                Set(weight: 10, reps: 10)
                             ])
                ])
    ]
    
    @Published var exercises: [Exercise] = [
        Exercise(title: "Bench press",
                 type: .repBased,
                 sets: [
                    Set(weight: 5, reps: 10)
                 ]),
        Exercise(title: "Reverse Lunges",
                 type: .repBased,
                 sets: [
                    Set(weight: 10, reps: 10),
                    Set(weight: 10, reps: 10),
                    Set(weight: 10, reps: 10)
                 ]),
        Exercise(title: "Deadlift",
                 type: .repBased,
                 sets: [
                    Set(weight: 10, reps: 10),
                    Set(weight: 20, reps: 8),
                    Set(weight: 35, reps: 5)
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
            if var values = schedule[key] {
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
    
    //MARK: - Handle Exercise Collection
    
    func addExerciseToCollection(_ exercise: Exercise) {
        exercises.append(exercise)
    }
    
    func removeExerciseFromCollection(_ exercise: Exercise) {
        exercises.removeAll(where: { $0.id == exercise.id } )
    }
    
    func updateExercise(_ exercise: Exercise) {
        if let index = exercises.firstIndex(where: { $0.id == exercise.id } ) {
            exercises[index] = exercise
        }
    }
    
    //MARK: - Compare Workouts/Exercises/Sets
    
    func workoutsAreEqual(workout1 w1: Workout, workout2 w2: Workout) -> Bool {
        var result = false
        
        if w1.title == w2.title && w1.details == w2.details {
            if w1.exercises.count == w2.exercises.count {
                var index = 0
                
                repeat {
                    result = self.exercisesAreEqual(exercise1: w1.exercises[index],
                                                    exercise2: w2.exercises[index])
                    if !result {
                        break
                    }
                    
                    index += 1
                } while index < w1.exercises.count
            } else {
                return false
            }
        } else {
            return false
        }
        
        return result
    }
    
    func exercisesAreEqual(exercise1 ex1: Exercise, exercise2 ex2: Exercise) -> Bool {
        var result = false
        
        if ex1.title == ex2.title {
            if ex1.sets.count == ex2.sets.count && ex1.type == ex2.type {
                var index = 0
                
                repeat {
                    result = self.setsAreEqual(set1: ex1.sets[index], set2: ex2.sets[index])
                    if !result {
                        break
                    }
                    
                    index += 1
                } while index < ex1.sets.count
            } else {
                return false
            }
        } else {
            return false
        }
        
        return result
    }
    
    func setsAreEqual(set1 s1: Set, set2 s2: Set) -> Bool {
        var result = false
        
        if s1.reps == s2.reps && s1.duration == s2.duration && s1.weight == s2.weight && s1.rest == s2.rest {
            result = true
        }
        
        return result
    }
}

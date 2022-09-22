//
//  WorkoutManager.swift
//  FitnessApp
//
//  Created by Robert Basamac on 27.04.2022.
//

import Foundation
import CoreData
import Combine

class WorkoutManager: ObservableObject {
    
    let coreDataManager = CoreDataManager.shared
    
    @Published var CDworkouts: [WorkoutEntity] = []
    @Published var CDexercises: [StoreExerciseEntity] = []
        
    @Published var schedule: [String: [String]] = [:]
    @Published var workouts: [WorkoutModel] = []
    @Published var exercises: [ExerciseModel] = []
    
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
        getWorkoutsFromCollection()
        getExercisesFromCollection()
    }


//MARK: - Public
    
    //MARK: - Create Entities
    func addWorkoutToCollection(workout: WorkoutModel) {
        var entity = WorkoutEntity(context: coreDataManager.context)
        
        updateWorkoutEntity(entity: &entity, workout: workout)
        
        save()
    }
    
    func addExerciseToCollection(exercise: ExerciseModel) {
        var entity = StoreExerciseEntity(context: coreDataManager.context)
        
        updateExerciseEntity(entity: &entity, exercise: exercise)
        
        save()
    }
    
    //MARK: - Update Entities
    func updateWorkout(_ workout: WorkoutModel) {
        var entities: [WorkoutEntity] = []
        
        let request = NSFetchRequest<WorkoutEntity>(entityName: "WorkoutEntity")
        
        let filter = NSPredicate(format: "id == %@", workout.id)
        request.predicate = filter
        
        do {
            entities = try coreDataManager.context.fetch(request)
        } catch let error {
            print("Error fetching workout for update, \(error.localizedDescription)")
        }
        
        guard !entities.isEmpty, var entity = entities.first else {
            print("No workout with id = \(workout.id) found.")
            return
        }
        
        updateWorkoutEntity(entity: &entity, workout: workout)
        save()
    }
    
    func updateExercise(_ exercise: ExerciseModel) {
        var entities: [StoreExerciseEntity] = []
        
        let request = NSFetchRequest<StoreExerciseEntity>(entityName: "StoreExerciseEntity")
        
        let filter = NSPredicate(format: "id == %@", exercise.id)
        request.predicate = filter
        
        do {
            entities = try coreDataManager.context.fetch(request)
        } catch let error {
            print("Error fetching exercise for update, \(error.localizedDescription)")
        }
        
        guard !entities.isEmpty, var entity = entities.first else {
            print("No exercise with id = \(exercise.id) found.")
            return
        }
        
        updateExerciseEntity(entity: &entity, exercise: exercise)
        save()
    }
    
    //MARK: - Delete Entities
    func deleteWorkoutFromCollection(_ workout: WorkoutModel) {
        var entities: [WorkoutEntity] = []
        
        let request = NSFetchRequest<WorkoutEntity>(entityName: "WorkoutEntity")
        
        let filter = NSPredicate(format: "id == %@", workout.id)
        request.predicate = filter
        
        do {
            entities = try coreDataManager.context.fetch(request)
        } catch let error {
            print("Error fetching workout for deletion, \(error.localizedDescription)")
        }
        
        guard !entities.isEmpty, let entity = entities.first else {
            print("No workout with id = \(workout.id) found.")
            return
        }
        
        deleteWorkoutEntity(entity)
    }
    
    func deleteExerciseFromCollection(_ exercise: ExerciseModel) {
        var entities: [StoreExerciseEntity] = []
        
        let request = NSFetchRequest<StoreExerciseEntity>(entityName: "StoreExerciseEntity")
        
        let filter = NSPredicate(format: "id == %@", exercise.id)
        request.predicate = filter
        
        do {
            entities = try coreDataManager.context.fetch(request)
        } catch let error {
            print("Error fetching exercise for deletion, \(error.localizedDescription)")
        }
        
        guard !entities.isEmpty, let entity = entities.first else {
            print("No exercise with id = \(exercise.id) found.")
            return
        }
        
        deleteExerciseEntity(entity)
    }


//MARK: - Private
    
    private func addSubscribers() {
        $CDworkouts
            .map(mapWorkoutEntitiesToWorkoutModels)
            .sink { [weak self] returnedWorkouts in
                guard let self = self else { return }
                
                self.workouts = returnedWorkouts
            }
            .store(in: &cancellables)
        
        $CDexercises
            .map(mapStoreExerciseEntitiesToExerciseModels)
            .sink { [weak self] returnedExercises in
                guard let self = self else { return }
                
                self.exercises = returnedExercises
            }
            .store(in: &cancellables)
    }
    
    //MARK: - Map Core Data WorkoutEntities to WorkoutModels
    private func mapWorkoutEntitiesToWorkoutModels(workoutEntities: [WorkoutEntity]) -> [WorkoutModel] {
        var workouts: [WorkoutModel] = []
        
        for workoutEntity in workoutEntities {
            var workoutModel: WorkoutModel = WorkoutModel()
            
            workoutModel.id = workoutEntity.id
            workoutModel.title = workoutEntity.title
            workoutModel.details = workoutEntity.details
            
            if let exerciseEntities = workoutEntity.exercises?.sortedArray(using: [NSSortDescriptor(key: "number", ascending: true)])  as? [ExerciseEntity] {
                workoutModel.exercises = mapExerciseEntitiesToExerciseModels(exerciseEntities: exerciseEntities)
            }
                        
            workouts.append(workoutModel)
        }
                
        return workouts
    }
    
    private func mapExerciseEntitiesToExerciseModels(exerciseEntities: [ExerciseEntity]) -> [ExerciseModel] {
        var exercises: [ExerciseModel] = []
        
        for exerciseEntity in exerciseEntities {
            var exerciseModel: ExerciseModel = ExerciseModel()
            
            exerciseModel.id = exerciseEntity.id
            exerciseModel.title = exerciseEntity.title
            exerciseModel.instructions = exerciseEntity.instructions
            exerciseModel.type = exerciseEntity.type ? .repBased : .timeBased
            
            if let setEntities = exerciseEntity.sets?.sortedArray(using: [NSSortDescriptor(key: "number", ascending: true)]) as? [SetEntity] {
                exerciseModel.sets = mapSetEntitiesToSetModels(setEntities: setEntities)
            }
            
            exercises.append(exerciseModel)
        }
                
        return exercises
    }
    
    private func mapSetEntitiesToSetModels(setEntities: [SetEntity]) -> [SetModel] {
        var sets: [SetModel] = []
        
        for setEntity in setEntities {
            var setModel: SetModel = SetModel()
            
            setModel.weight = setEntity.weight
            setModel.reps = Int(setEntity.reps)
            setModel.duration = Int(setEntity.duration)
            setModel.rest = Int(setEntity.rest)
            
            sets.append(setModel)
        }
        
        return sets
    }
    
    //MARK: - Map Core Data StoreExerciseEntities to ExerciseModels
    private func mapStoreExerciseEntitiesToExerciseModels(exerciseEntities: [StoreExerciseEntity]) -> [ExerciseModel] {
        var exercises: [ExerciseModel] = []
        
        for exerciseEntity in exerciseEntities {
            var exerciseModel: ExerciseModel = ExerciseModel()
            
            exerciseModel.id = exerciseEntity.id
            exerciseModel.title = exerciseEntity.title
            exerciseModel.instructions = exerciseEntity.instructions
            exerciseModel.type = exerciseEntity.type ? .repBased : .timeBased
                        
            if let setEntities = exerciseEntity.sets?.sortedArray(using: [NSSortDescriptor(key: "number", ascending: true)]) as? [StoreSetEntity] {
                exerciseModel.sets = mapStoreSetEntitiesToSetModels(setEntities: setEntities)
            }
            
            exercises.append(exerciseModel)
        }
                
        return exercises
    }
    
    private func mapStoreSetEntitiesToSetModels(setEntities: [StoreSetEntity]) -> [SetModel] {
        var sets: [SetModel] = []
        
        for setEntity in setEntities {
            var setModel: SetModel = SetModel()
            
            setModel.weight = setEntity.weight
            setModel.reps = Int(setEntity.reps)
            setModel.duration = Int(setEntity.duration)
            setModel.rest = Int(setEntity.rest)
            
            sets.append(setModel)
        }
        
        return sets
    }
    
    //MARK: - Update Entities content based on a Model
    private func updateWorkoutEntity(entity: inout WorkoutEntity, workout: WorkoutModel) {
        // delete old content
        if let exercises = entity.exercises?.allObjects as? [ExerciseEntity] {
            for exercise in exercises {
                coreDataManager.context.delete(exercise)
            }
        }
        
        // update the entity with the new content
        var exerciseEntities: [ExerciseEntity] = []
        
        for index in workout.exercises.indices {
            let exerciseEntity = ExerciseEntity(context: coreDataManager.context)
            var setEntities: [SetEntity] = []
            
            for setIndex in workout.exercises[index].sets.indices {
                let setEntity = SetEntity(context: coreDataManager.context)
                
                let setToCopy = workout.exercises[index].sets[setIndex]
                setEntity.weight = setToCopy.weight
                setEntity.reps = Int64(setToCopy.reps)
                setEntity.duration = Int64(setToCopy.duration)
                setEntity.rest = Int64(setToCopy.rest)
                setEntity.number = Int16(setIndex)
                
                setEntities.append(setEntity)
            }
            
            let exerciseToCopy = workout.exercises[index]
            exerciseEntity.id = exerciseToCopy.id
            exerciseEntity.title = exerciseToCopy.title
            exerciseEntity.instructions = exerciseToCopy.instructions
            exerciseEntity.sets = NSSet(array: setEntities)
            exerciseEntity.type = exerciseToCopy.type == .repBased ? true : false
            exerciseEntity.number = Int16(index)

            exerciseEntities.append(exerciseEntity)
        }
        
        entity.id = workout.id
        entity.title = workout.title
        entity.details = workout.details
        entity.exercises = NSSet(array: exerciseEntities)
    }
    
    private func updateExerciseEntity(entity: inout StoreExerciseEntity, exercise: ExerciseModel) {
        // delete old content
        if let sets = entity.sets?.allObjects as? [StoreSetEntity] {
            for set in sets {
                coreDataManager.context.delete(set)
            }
        }
        
        // update the entity with the new content
        var setEntities: [StoreSetEntity] = []
        
        for index in exercise.sets.indices {
            let setEntity = StoreSetEntity(context: coreDataManager.context)
            
            let setToCopy = exercise.sets[index]
            setEntity.weight = setToCopy.weight
            setEntity.reps = Int64(setToCopy.reps)
            setEntity.duration = Int64(setToCopy.duration)
            setEntity.rest = Int64(setToCopy.rest)
            setEntity.number = Int16(index)
            
            setEntities.append(setEntity)
        }
        
        entity.id = exercise.id
        entity.title = exercise.title
        entity.instructions = exercise.instructions
        entity.type = exercise.type == .repBased ? true : false
        entity.sets = NSSet(array: setEntities)
    }
    
    //MARK: - Delete Entities from Collection
    private func deleteWorkoutEntity(_ workout: WorkoutEntity) {
//        if let exercises = workout.exercises?.allObjects as? [ExerciseEntity] {
//            for exercise in exercises {
//                exercise.removeFromWorkouts(workout)
//
//                if exercise.workouts?.count == 0 {
//                    coreDataManager.context.delete(exercise)
//                }
//            }
//        }
        
        coreDataManager.context.delete(workout)
        save()
    }
    
    private func deleteExerciseEntity(_ exercise: StoreExerciseEntity) {
        coreDataManager.context.delete(exercise)
        save()
    }
    
    //MARK: - Get Entities from Collection
    private func getWorkoutsFromCollection() {
        let request = NSFetchRequest<WorkoutEntity>(entityName: "WorkoutEntity")
        
        do {
            CDworkouts = try coreDataManager.context.fetch(request)
        } catch let error {
            print("Error fetching Workouts, \(error.localizedDescription)")
        }
    }
    
    private func getExercisesFromCollection() {
        let request = NSFetchRequest<StoreExerciseEntity>(entityName: "StoreExerciseEntity")
        
        do {
            CDexercises = try coreDataManager.context.fetch(request)
        } catch let error {
            print("Error fetching Exercises, \(error.localizedDescription)")
        }
    }
    
    private func save() {
        coreDataManager.save()
        getWorkoutsFromCollection()
        getExercisesFromCollection()
    }
}

//MARK: - Handle Workout Schedule
extension WorkoutManager {
    func hasWorkouts(for day: String) -> Bool {
        return schedule.keys.contains(day)
    }
    
    func assignWorkout(_ workout: WorkoutModel, for day: String) {
        if var mergedWorkouts = schedule[day] {
            mergedWorkouts.append(workout.id)
            schedule.updateValue(mergedWorkouts, forKey: day)
        } else {
            schedule.updateValue([workout.id], forKey: day)
        }
    }
    
    func getWorkouts(for day: String) -> [WorkoutModel]? {
        if let workoutIDs = schedule[day] {
            var result: [WorkoutModel] = []
            
            for workout in self.workouts {
                if workoutIDs.contains(workout.id) {
                    result.append(workout)
                }
            }
            
            return result
        }
        
        return nil
    }
    
    //MARK: - Compare Workouts/Exercises/Sets
    func workoutsAreEqual(workout1 w1: WorkoutModel, workout2 w2: WorkoutModel) -> Bool {
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
    
    func exercisesAreEqual(exercise1 ex1: ExerciseModel, exercise2 ex2: ExerciseModel) -> Bool {
        var result = false
        
        if ex1.title == ex2.title {
            if ex1.sets.count == ex2.sets.count && ex1.type == ex2.type  && ex1.sets.count > 0 {
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
    
    func setsAreEqual(set1 s1: SetModel, set2 s2: SetModel) -> Bool {
        var result = false
        
        if s1.reps == s2.reps && s1.duration == s2.duration && s1.weight == s2.weight && s1.rest == s2.rest {
            result = true
        }
        
        return result
    }
}

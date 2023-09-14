//
//  WorkoutManager.swift
//  FitnessApp
//
//  Created by Robert Basamac on 27.04.2022.
//

import Foundation
import CoreData
import Combine

class WorkoutViewModel: ObservableObject {
    
// MARK:
    let coreDataManager = CoreDataManager.shared
    
    @Published var CDschedule: [ScheduleEntity] = []
    @Published var CDworkouts: [WorkoutEntity] = []
    @Published var CDexercises: [StoreExerciseEntity] = []
        
    @Published var schedule: [ScheduleModel] = []
    @Published var workouts: [WorkoutModel] = []
    @Published var exercises: [ExerciseModel] = []
    
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
        getWorkoutsFromCollection()
        getExercisesFromCollection()
        getScheduleFromCollection()
    }
    
    // MARK: - Create Entities
    func addWorkoutToCollection(workout: WorkoutModel) {
        var entity = WorkoutEntity(context: coreDataManager.context)
        
        updateWorkoutEntityFromModel(workoutEntity: &entity, workoutModel: workout)
        save()
    }
    
    func addExerciseToCollection(exercise: ExerciseModel) {
        var entity = StoreExerciseEntity(context: coreDataManager.context)
        
        updateExerciseEntityFromModel(exerciseEntity: &entity, exerciseModel: exercise)
        save()
    }
    
    // MARK: - Update Entities
    func updateWorkout(_ workout: WorkoutModel) {
        let entities: [WorkoutEntity] = fetchWorkoutEntities(forId: workout.id)
        
        guard !entities.isEmpty, var entity = entities.first else {
            print("No workout with id = \(workout.id) found.")
            return
        }
        
        updateWorkoutEntityFromModel(workoutEntity: &entity, workoutModel: workout)
        save()
    }
    
    func updateExercise(_ exercise: ExerciseModel) {
        let entities: [StoreExerciseEntity] = fetchExerciseEntities(forId: exercise.id)
        
        guard !entities.isEmpty, var entity = entities.first else {
            print("No exercise with id = \(exercise.id) found.")
            return
        }
        
        updateExerciseEntityFromModel(exerciseEntity: &entity, exerciseModel: exercise)
        save()
    }
    
    // MARK: - Delete Entities
    func deleteWorkoutFromCollection(_ workout: WorkoutModel) {
        let entities: [WorkoutEntity] = fetchWorkoutEntities(forId: workout.id)
        
        guard !entities.isEmpty, let entity = entities.first else {
            print("No workout with id = \(workout.id) found.")
            return
        }
        
        deleteWorkoutEntity(entity)
    }
    
    func deleteWorkoutFromCollection(atOffsets indexSet: IndexSet) {
        indexSet.map { workouts[$0] }.forEach(deleteWorkoutFromCollection)
    }
    
    func deleteExerciseFromCollection(_ exercise: ExerciseModel) {
        let entities: [StoreExerciseEntity] = fetchExerciseEntities(forId: exercise.id)
        
        guard !entities.isEmpty, let entity = entities.first else {
            print("No exercise with id = \(exercise.id) found.")
            return
        }
        
        deleteExerciseEntity(entity)
    }

    // MARK: Handle Workout Schedule
    func scheduleWorkout(_ workout: WorkoutModel, toDate date: String) {
        if schedule.contains(where: { $0.date == date }) {
            let scheduleEntities: [ScheduleEntity] = fetchScheduleEntities(forDate: date)
            guard !scheduleEntities.isEmpty, let scheduleEntity = scheduleEntities.first else {
                print("No schedule for date = \(date) found.")
                return
            }
            
            let workoutEntities: [WorkoutEntity] = fetchWorkoutEntities(forId: workout.id)
            guard !workoutEntities.isEmpty, let workoutEntity = workoutEntities.first else {
                print("No workout with id = \(workout.id) found.")
                return
            }
            
            scheduleEntity.addToWorkouts(workoutEntity)
        } else {
            let scheduleEntity = ScheduleEntity(context: coreDataManager.context)
            
            let workoutEntities: [WorkoutEntity] = fetchWorkoutEntities(forId: workout.id)
            guard !workoutEntities.isEmpty, let workoutEntity = workoutEntities.first else {
                print("No workout with id = \(workout.id) found.")
                return
            }
            
            scheduleEntity.date = date
            scheduleEntity.addToWorkouts(workoutEntity)
        }
        
        save()
    }
    
    func hasWorkouts(forDate date: String) -> Bool {
        if schedule.contains(where: { $0.date == date }) {
            return true
        } else {
            return false
        }
    }
    
    func getWorkouts(forDate date: String) -> [WorkoutModel]? {
        if let scheduleForDate = schedule.first(where: { $0.date == date }) {
            let workoutIDs = scheduleForDate.workoutIDs
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
    
    func deleteWorkoutFromSchedule(_ workout: WorkoutModel, forDate date: String) {
        let scheduleEntities: [ScheduleEntity] = fetchScheduleEntities(forDate: date)
        guard !scheduleEntities.isEmpty, let scheduleEntity = scheduleEntities.first else {
            print("No schedule for date = \(date) found.")
            return
        }
        
        let workoutEntities: [WorkoutEntity] = fetchWorkoutEntities(forId: workout.id)
        guard !workoutEntities.isEmpty, let workoutEntity = workoutEntities.first else {
            print("No workout with id = \(workout.id) found.")
            return
        }
        
        scheduleEntity.removeFromWorkouts(workoutEntity)

        if scheduleEntity.workouts.count == 0 {
            coreDataManager.context.delete(scheduleEntity)
        }
        
        save()
    }

// MARK: Private
    
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
        
        $CDschedule
            .map(mapScheduleEntitiesToScheduleModels)
            .sink { [weak self] returnedSchedule in
                guard let self = self else { return }
                
                self.schedule = returnedSchedule
            }
            .store(in: &cancellables)
    }
    
    // MARK: Map Core Data ScheduleEntities to ScheduleModels
    private func mapScheduleEntitiesToScheduleModels(scheduleEntities: [ScheduleEntity]) -> [ScheduleModel] {
        var schedule: [ScheduleModel] = []
        
        for scheduleEntity in scheduleEntities {
            var scheduleModel: ScheduleModel = ScheduleModel()
            var workoutIDs: [String] = []
            
            let workoutEntities = scheduleEntity.workouts.allObjects as! [WorkoutEntity]
            for entity in workoutEntities {
                workoutIDs.append(entity.id)
            }
            
            scheduleModel.date = scheduleEntity.date
            scheduleModel.workoutIDs = workoutIDs
            
            schedule.append(scheduleModel)
        }
        
        return schedule
    }
    
    // MARK: Map Core Data WorkoutEntities to WorkoutModels
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
    
    // MARK: Map Core Data StoreExerciseEntities to ExerciseModels
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
    
    // MARK: Update Entities content based on a Model
    private func updateWorkoutEntityFromModel(workoutEntity: inout WorkoutEntity, workoutModel: WorkoutModel) {
        // delete old content
        if let exercises = workoutEntity.exercises?.allObjects as? [ExerciseEntity] {
            for exercise in exercises {
                coreDataManager.context.delete(exercise)
            }
        }
        
        // update the entity with the new content
        var exerciseEntities: [ExerciseEntity] = []
        
        for index in workoutModel.exercises.indices {
            let exerciseEntity = ExerciseEntity(context: coreDataManager.context)
            var setEntities: [SetEntity] = []
            
            for setIndex in workoutModel.exercises[index].sets.indices {
                let setEntity = SetEntity(context: coreDataManager.context)
                
                let setToCopy = workoutModel.exercises[index].sets[setIndex]
                setEntity.weight = setToCopy.weight
                setEntity.reps = Int64(setToCopy.reps)
                setEntity.duration = Int64(setToCopy.duration)
                setEntity.rest = Int64(setToCopy.rest)
                setEntity.number = Int16(setIndex)
                
                setEntities.append(setEntity)
            }
            
            let exerciseToCopy = workoutModel.exercises[index]
            exerciseEntity.id = exerciseToCopy.id
            exerciseEntity.title = exerciseToCopy.title
            exerciseEntity.instructions = exerciseToCopy.instructions
            exerciseEntity.sets = NSSet(array: setEntities)
            exerciseEntity.type = exerciseToCopy.type == .repBased ? true : false
            exerciseEntity.number = Int16(index)

            exerciseEntities.append(exerciseEntity)
        }
        
        workoutEntity.id = workoutModel.id
        workoutEntity.title = workoutModel.title
        workoutEntity.details = workoutModel.details
        workoutEntity.exercises = NSSet(array: exerciseEntities)
    }
    
    private func updateExerciseEntityFromModel(exerciseEntity: inout StoreExerciseEntity, exerciseModel: ExerciseModel) {
        // delete old content
        if let sets = exerciseEntity.sets?.allObjects as? [StoreSetEntity] {
            for set in sets {
                coreDataManager.context.delete(set)
            }
        }
        
        // update the entity with the new content
        var setEntities: [StoreSetEntity] = []
        
        for index in exerciseModel.sets.indices {
            let setEntity = StoreSetEntity(context: coreDataManager.context)
            
            let setToCopy = exerciseModel.sets[index]
            setEntity.weight = setToCopy.weight
            setEntity.reps = Int64(setToCopy.reps)
            setEntity.duration = Int64(setToCopy.duration)
            setEntity.rest = Int64(setToCopy.rest)
            setEntity.number = Int16(index)
            
            setEntities.append(setEntity)
        }
        
        exerciseEntity.id = exerciseModel.id
        exerciseEntity.title = exerciseModel.title
        exerciseEntity.instructions = exerciseModel.instructions
        exerciseEntity.type = exerciseModel.type == .repBased ? true : false
        exerciseEntity.sets = NSSet(array: setEntities)
    }
    
    // MARK: Delete Entities from Collection
    private func deleteWorkoutEntity(_ workout: WorkoutEntity) {
        if let scheduleEntities: [ScheduleEntity] = workout.schedules?.allObjects as? [ScheduleEntity] {
            for scheduleEntity in scheduleEntities {
                scheduleEntity.removeFromWorkouts(workout)

                if scheduleEntity.workouts.count == 0 {
                    coreDataManager.context.delete(scheduleEntity)
                }
            }
        }
        
        coreDataManager.context.delete(workout)
        save()
    }
    
    private func deleteExerciseEntity(_ exercise: StoreExerciseEntity) {
        coreDataManager.context.delete(exercise)
        save()
    }
    
    // MARK: Get Entities from Collection
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
    
    private func getScheduleFromCollection() {
        let request = NSFetchRequest<ScheduleEntity>(entityName: "ScheduleEntity")
        
        do {
            CDschedule = try coreDataManager.context.fetch(request)
        } catch let error {
            print("Error fetching Schedule, \(error.localizedDescription)")
        }
    }
    
    private func fetchScheduleEntities(forDate date: String) -> [ScheduleEntity] {
        var entities: [ScheduleEntity] = []
        
        let request = NSFetchRequest<ScheduleEntity>(entityName: "ScheduleEntity")
        
        let filter = NSPredicate(format: "date == %@", date)
        request.predicate = filter
        
        do {
            entities = try coreDataManager.context.fetch(request)
        } catch let error {
            print("Error fetching Schedule for date = \(date), \(error.localizedDescription)")
        }
        
        return entities
    }
    
    private func fetchWorkoutEntities(forId id: String) -> [WorkoutEntity] {
        var entities: [WorkoutEntity] = []
        
        let request = NSFetchRequest<WorkoutEntity>(entityName: "WorkoutEntity")
        
        let filter = NSPredicate(format: "id == %@", id)
        request.predicate = filter
        
        do {
            entities = try coreDataManager.context.fetch(request)
        } catch let error {
            print("Error fetching Workout for id = \(id), \(error.localizedDescription)")
        }
        
        return entities
    }
    
    private func fetchExerciseEntities(forId id: String) -> [StoreExerciseEntity] {
        var entities: [StoreExerciseEntity] = []
        
        let request = NSFetchRequest<StoreExerciseEntity>(entityName: "StoreExerciseEntity")
        
        let filter = NSPredicate(format: "id == %@", id)
        request.predicate = filter
        
        do {
            entities = try coreDataManager.context.fetch(request)
        } catch let error {
            print("Error fetching Exercise for update, \(error.localizedDescription)")
        }
        
        return entities
    }
    
    private func save() {
        coreDataManager.save()
        getWorkoutsFromCollection()
        getExercisesFromCollection()
        getScheduleFromCollection()
    }
    
    // MARK: Compare Workouts/Exercises/Sets
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
        
        if ex1.title == ex2.title && ex1.instructions == ex2.instructions {
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

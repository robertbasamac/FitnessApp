//
//  ExerciseEntity+CoreDataProperties.swift
//  FitnessApp
//
//  Created by Robert Basamac on 21.09.2022.
//
//

import Foundation
import CoreData


extension ExerciseEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExerciseEntity> {
        return NSFetchRequest<ExerciseEntity>(entityName: "ExerciseEntity")
    }

    @NSManaged public var id: String
    @NSManaged public var title: String
    @NSManaged public var instructions: String
    @NSManaged public var type: Bool
    @NSManaged public var number: Int16
    @NSManaged public var sets: NSSet?
    @NSManaged public var workouts: NSSet?

}

// MARK: Generated accessors for sets
extension ExerciseEntity {

    @objc(addSetsObject:)
    @NSManaged public func addToSets(_ value: SetEntity)

    @objc(removeSetsObject:)
    @NSManaged public func removeFromSets(_ value: SetEntity)

    @objc(addSets:)
    @NSManaged public func addToSets(_ values: NSSet)

    @objc(removeSets:)
    @NSManaged public func removeFromSets(_ values: NSSet)

}

// MARK: Generated accessors for workouts
extension ExerciseEntity {

    @objc(addWorkoutsObject:)
    @NSManaged public func addToWorkouts(_ value: WorkoutEntity)

    @objc(removeWorkoutsObject:)
    @NSManaged public func removeFromWorkouts(_ value: WorkoutEntity)

    @objc(addWorkouts:)
    @NSManaged public func addToWorkouts(_ values: NSSet)

    @objc(removeWorkouts:)
    @NSManaged public func removeFromWorkouts(_ values: NSSet)

}

extension ExerciseEntity : Identifiable {

}

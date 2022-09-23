//
//  WorkoutEntity+CoreDataProperties.swift
//  FitnessApp
//
//  Created by Robert Basamac on 22.09.2022.
//
//

import Foundation
import CoreData


extension WorkoutEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkoutEntity> {
        return NSFetchRequest<WorkoutEntity>(entityName: "WorkoutEntity")
    }

    @NSManaged public var details: String
    @NSManaged public var id: String
    @NSManaged public var title: String
    @NSManaged public var exercises: NSSet?
    @NSManaged public var schedules: NSSet?

}

// MARK: Generated accessors for exercises
extension WorkoutEntity {

    @objc(addExercisesObject:)
    @NSManaged public func addToExercises(_ value: ExerciseEntity)

    @objc(removeExercisesObject:)
    @NSManaged public func removeFromExercises(_ value: ExerciseEntity)

    @objc(addExercises:)
    @NSManaged public func addToExercises(_ values: NSSet)

    @objc(removeExercises:)
    @NSManaged public func removeFromExercises(_ values: NSSet)

}

// MARK: Generated accessors for schedules
extension WorkoutEntity {

    @objc(addSchedulesObject:)
    @NSManaged public func addToSchedules(_ value: ScheduleEntity)

    @objc(removeSchedulesObject:)
    @NSManaged public func removeFromSchedules(_ value: ScheduleEntity)

    @objc(addSchedules:)
    @NSManaged public func addToSchedules(_ values: NSSet)

    @objc(removeSchedules:)
    @NSManaged public func removeFromSchedules(_ values: NSSet)

}

extension WorkoutEntity : Identifiable {

}

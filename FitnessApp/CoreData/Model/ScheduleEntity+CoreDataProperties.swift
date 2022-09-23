//
//  ScheduleEntity+CoreDataProperties.swift
//  FitnessApp
//
//  Created by Robert Basamac on 22.09.2022.
//
//

import Foundation
import CoreData


extension ScheduleEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ScheduleEntity> {
        return NSFetchRequest<ScheduleEntity>(entityName: "ScheduleEntity")
    }

    @NSManaged public var date: String
    @NSManaged public var workouts: NSSet

}

// MARK: Generated accessors for workoutIDs
extension ScheduleEntity {

    @objc(addWorkoutsObject:)
    @NSManaged public func addToWorkouts(_ value: WorkoutEntity)

    @objc(removeWorkoutsObject:)
    @NSManaged public func removeFromWorkouts(_ value: WorkoutEntity)

    @objc(addWorkouts:)
    @NSManaged public func addToWorkouts(_ values: NSSet)

    @objc(removeWorkouts:)
    @NSManaged public func removeFromWorkouts(_ values: NSSet)

}

extension ScheduleEntity : Identifiable {

}

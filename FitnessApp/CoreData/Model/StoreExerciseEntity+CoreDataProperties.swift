//
//  StoreExerciseEntity+CoreDataProperties.swift
//  FitnessApp
//
//  Created by Robert Basamac on 21.09.2022.
//
//

import Foundation
import CoreData


extension StoreExerciseEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StoreExerciseEntity> {
        return NSFetchRequest<StoreExerciseEntity>(entityName: "StoreExerciseEntity")
    }

    @NSManaged public var id: String
    @NSManaged public var title: String
    @NSManaged public var instructions: String
    @NSManaged public var type: Bool
    @NSManaged public var sets: NSSet?

}

// MARK: Generated accessors for sets
extension StoreExerciseEntity {

    @objc(addSetsObject:)
    @NSManaged public func addToSets(_ value: StoreSetEntity)

    @objc(removeSetsObject:)
    @NSManaged public func removeFromSets(_ value: StoreSetEntity)

    @objc(addSets:)
    @NSManaged public func addToSets(_ values: NSSet)

    @objc(removeSets:)
    @NSManaged public func removeFromSets(_ values: NSSet)

}

extension StoreExerciseEntity : Identifiable {

}

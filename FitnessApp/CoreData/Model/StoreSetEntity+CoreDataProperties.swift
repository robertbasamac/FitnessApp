//
//  StoreSetEntity+CoreDataProperties.swift
//  FitnessApp
//
//  Created by Robert Basamac on 21.09.2022.
//
//

import Foundation
import CoreData


extension StoreSetEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StoreSetEntity> {
        return NSFetchRequest<StoreSetEntity>(entityName: "StoreSetEntity")
    }

    @NSManaged public var weight: Double
    @NSManaged public var reps: Int64
    @NSManaged public var duration: Int64
    @NSManaged public var rest: Int64
    @NSManaged public var number: Int16
    @NSManaged public var exercise: StoreExerciseEntity?

}

extension StoreSetEntity : Identifiable {

}

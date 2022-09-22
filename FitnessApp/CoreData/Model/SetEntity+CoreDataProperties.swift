//
//  SetEntity+CoreDataProperties.swift
//  FitnessApp
//
//  Created by Robert Basamac on 21.09.2022.
//
//

import Foundation
import CoreData


extension SetEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SetEntity> {
        return NSFetchRequest<SetEntity>(entityName: "SetEntity")
    }

    @NSManaged public var weight: Double
    @NSManaged public var reps: Int64
    @NSManaged public var duration: Int64
    @NSManaged public var rest: Int64
    @NSManaged public var number: Int16
    @NSManaged public var exercise: ExerciseEntity?

}

extension SetEntity : Identifiable {

}

//
//  CoreDataViewModel.swift
//  FitnessApp
//
//  Created by Robert Basamac on 03.08.2022.
//

import Foundation
import CoreData

class CoreDataManager {

    static let shared = CoreDataManager()

    let container: NSPersistentContainer
    let context: NSManagedObjectContext

    init() {
        container = NSPersistentContainer(name: "CollectionContainer")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("ERROR LOADING CORE DATA: \(error).")
            } else {
                print("Succesfully laoded the core data.")
            }
        }

        context = container.viewContext
    }

    func save() {
        do {
            try context.save()
            print("Succesfully saved the core data.")
        } catch let error {
            print("Error saving Core Data: \(error.localizedDescription).")
        }
    }
}

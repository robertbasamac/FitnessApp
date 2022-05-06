//
//  Exercise.swift
//  FitnessApp
//
//  Created by Robert Basamac on 21.04.2022.
//

import Foundation

class Exercise: Identifiable {
    var id: String = UUID().uuidString
    var title: String
//    var numberOfSets: Int               // The number of performed sets for this exercise.
//    var useSameSet: Bool                // Indicating if the same Set will be used for numberOfSets tiems.
//    var recoveryTimeBetweenSets: Int    // The whole recovery pause between sets. It includes preparingTime also and cannot be lower than preparingTime.
//    var preparingTime: Int              // Used to announce the user to start preparing for the new set.
//    var sets: [Set]                     // Number of sets performed.
//    
//    init(title: String, numberOfSets: Int, useSameSet: Bool, recoveryTimeBetweenSets: Int, preparingTime: Int, sets: [Set]) {
//        self.title = title
//        self.numberOfSets = numberOfSets
//        self.useSameSet = useSameSet
//        self.recoveryTimeBetweenSets = recoveryTimeBetweenSets
//        self.preparingTime = preparingTime
//        self.sets = sets
//    }
    
    init(title: String) {
        self.title = title
    }
}

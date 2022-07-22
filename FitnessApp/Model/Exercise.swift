//
//  Exercise.swift
//  FitnessApp
//
//  Created by Robert Basamac on 21.04.2022.
//

import Foundation

struct Exercise: Identifiable, Hashable {
    var id: String = UUID().uuidString
    var title: String = ""
    var instruction: String = ""
    var type: ExerciseType = .repBased
    var sets: [Set] = [Set()]
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title + type.rawValue + String(sets.count))
    }
}

enum ExerciseType: String, Equatable, CaseIterable {
    case repBased = "Rep based"
    case timeBased = "Time based"
}

//
//  Exercise.swift
//  FitnessApp
//
//  Created by Robert Basamac on 21.04.2022.
//

import Foundation

struct ExerciseModel: Identifiable, Hashable {
    var id: String = UUID().uuidString
    var title: String = ""
    var instructions: String = ""
    var type: ExerciseType = .repBased
    var sets: [SetModel] = []
}

enum ExerciseType: String, Equatable, CaseIterable {
    case repBased = "Rep based"
    case timeBased = "Time based"
}

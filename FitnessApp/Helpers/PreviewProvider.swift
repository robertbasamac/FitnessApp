//
//  PreviewProvider.swift
//  FitnessApp
//
//  Created by Robert Basamac on 12.09.2023.
//

import Foundation
import SwiftUI

extension PreviewProvider {
    
    static var dev: DeveloperPreview {
        return DeveloperPreview.shared
    }
}

class DeveloperPreview {
    
    static let shared = DeveloperPreview()
    
    private init() { }
    
    let workout = WorkoutModel(title: "Push day like no other",
                               details: "This workout will focus the upper body mostly, but it will target the lower body, especially the core, to perform the movements.",
                               exercises: [ExerciseModel(title: "Push ups",
                                                         instructions: "Come on.. do a fucking push ups!",
                                                         type: .repBased,
                                                         sets: [SetModel(weight: 0, duration: 0, rest: 60, reps: 20),
                                                                SetModel(weight: 0, duration: 0, rest: 60, reps: 15),
                                                                SetModel(weight: 0, duration: 0, rest: 60, reps: 10),
                                                               ]),
                                           ExerciseModel(title: "Pull ups",
                                                         instructions: "Come on.. do a fucking pull ups!",
                                                         type: .repBased,
                                                         sets: [SetModel(weight: 0, duration: 0, rest: 60, reps: 12),
                                                                SetModel(weight: 0, duration: 0, rest: 60, reps: 10),
                                                                SetModel(weight: 0, duration: 0, rest: 60, reps: 8),
                                                               ]),
                                           ExerciseModel(title: "Push ups",
                                                         instructions: "Come on.. do a fucking push ups!",
                                                         type: .repBased,
                                                         sets: [SetModel(weight: 0, duration: 0, rest: 60, reps: 20),
                                                                SetModel(weight: 0, duration: 0, rest: 60, reps: 15),
                                                                SetModel(weight: 0, duration: 0, rest: 60, reps: 10),
                                                               ]),
                                           ExerciseModel(title: "Pull ups",
                                                         instructions: "Come on.. do a fucking pull ups!",
                                                         type: .repBased,
                                                         sets: [SetModel(weight: 0, duration: 0, rest: 60, reps: 12),
                                                                SetModel(weight: 0, duration: 0, rest: 60, reps: 10),
                                                                SetModel(weight: 0, duration: 0, rest: 60, reps: 8),
                                                               ]),
                                           ExerciseModel(title: "Push ups",
                                                         instructions: "Come on.. do a fucking push ups!",
                                                         type: .repBased,
                                                         sets: [SetModel(weight: 0, duration: 0, rest: 60, reps: 20),
                                                                SetModel(weight: 0, duration: 0, rest: 60, reps: 15),
                                                                SetModel(weight: 0, duration: 0, rest: 60, reps: 10),
                                                               ]),
                                           ExerciseModel(title: "Pull ups",
                                                         instructions: "Come on.. do a fucking pull ups!",
                                                         type: .repBased,
                                                         sets: [SetModel(weight: 0, duration: 0, rest: 60, reps: 12),
                                                                SetModel(weight: 0, duration: 0, rest: 60, reps: 10),
                                                                SetModel(weight: 0, duration: 0, rest: 60, reps: 8),
                                                               ])
                               ])
}


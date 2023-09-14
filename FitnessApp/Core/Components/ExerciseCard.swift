//
//  ExerciseCard.swift
//  FitnessApp
//
//  Created by Robert Basamac on 13.09.2023.
//

import SwiftUI

struct ExerciseCard: View {
    var exercise: ExerciseModel
    
    init(exercise: ExerciseModel) {
        self.exercise = exercise
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(exercise.title)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.orange)
            
            if !exercise.instructions.isEmpty {
                Text(exercise.instructions)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
            }
        }
    }
    
    private func getExercisesTitlesString(from workout: WorkoutModel) -> String {
        let exerciseTitles = workout.exercises.map { $0.title.lowercased() }
        return exerciseTitles.joined(separator: ", ")
    }
}

#Preview {
    Form {
        ExerciseCard(exercise: ExerciseModel(title: "Push ups",
                                             instructions: "Come on.. do a fucking push up!",
                                             type: .repBased,
                                             sets: [SetModel(weight: 0, duration: 0, rest: 60, reps: 20),
                                                    SetModel(weight: 0, duration: 0, rest: 60, reps: 15),
                                                    SetModel(weight: 0, duration: 0, rest: 60, reps: 10),
                                                   ])
        )
    }
}

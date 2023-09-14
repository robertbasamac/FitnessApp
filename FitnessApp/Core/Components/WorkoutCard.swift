//
//  WorkoutCard.swift
//  FitnessApp
//
//  Created by Robert Basamac on 11.09.2023.
//

import SwiftUI

struct WorkoutCard: View {
    var workout: WorkoutModel
    private var exerciseTitles: String = ""
    
    init(workout: WorkoutModel) {
        self.workout = workout
        self.exerciseTitles = getExercisesTitlesString(from: workout)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(workout.title)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.orange)
            
            if !workout.details.isEmpty {
                Text(workout.details)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
                Divider()
            }
            
            Text(exerciseTitles)
                .font(.subheadline)
                .italic()
        }
        .hSpacing(.leading)
        .contentShape(.rect)
    }
    
    private func getExercisesTitlesString(from workout: WorkoutModel) -> String {
        let exerciseTitles = workout.exercises.map { $0.title.lowercased() }
        return exerciseTitles.joined(separator: ", ")
    }
}

struct WorkoutCard_Previews: PreviewProvider {
    static var previews: some View {
        Form {
            WorkoutCard(workout: dev.workout)
        }
    }
}

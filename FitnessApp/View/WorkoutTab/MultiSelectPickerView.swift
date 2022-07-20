//
//  SelectExercisesView.swift
//  FitnessApp
//
//  Created by Robert Basamac on 18.07.2022.
//

import SwiftUI

struct MultiSelectPickerView: View {
    
    @EnvironmentObject var workoutManager: WorkoutManager
    
    @Environment(\.dismiss) private var dismiss
    
    @Binding var workout: Workout
    @State var selectedExercises: [Exercise] = []
        
    var body: some View {
        List {
            ForEach(workoutManager.exercises) { exercise in
                ListRowView(exercise: exercise, selectedExercises: $selectedExercises)
            }
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    workout.exercises.append(contentsOf: selectedExercises)
                    dismiss()
                } label: {
                    Text("Done")
                }
                .disabled(selectedExercises.isEmpty)
            }
        }
    }
}

struct SelectExercisesView_Previews: PreviewProvider {
    static var previews: some View {
        BaseView()
            .environmentObject(WorkoutManager())
            .environmentObject(DateModel())
            .environmentObject(ViewRouter())
    }
}

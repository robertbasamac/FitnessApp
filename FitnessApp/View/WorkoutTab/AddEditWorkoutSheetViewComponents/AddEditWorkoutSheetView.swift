//
//  AddWorkoutView.swift
//  FitnessApp
//
//  Created by Robert Basamac on 07.05.2022.
//

import SwiftUI
import Combine

struct AddEditWorkoutSheetView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @EnvironmentObject var dateModel: DateModel
    
    @Environment(\.dismiss) private var dismiss
    
    @State var workout: Workout
    @Binding var editWorkout: Bool
       
    var workoutToCompare: Workout
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    AEWTitleSectionView(workout: $workout)
                    
                    AEWExerciseSectionView(workout: $workout)
                    
                    AddExerciseButton(workout: $workout)
                }
                .padding(.vertical, 40)
            }
            .navigationTitle(editWorkout ? "Edit Workout" : "Create new Workout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .cancel) {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                    .accessibilityLabel("Cancel adding/editing the Workout.")
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        if editWorkout {
                            workoutManager.updateWorkout(workout)
                        } else {
                            workoutManager.addWorkoutToCollection(workout)
                        }
                        dismiss()
                    } label: {
                        Text(editWorkout ? "Save" : "Add")
                    }
                    .accessibilityLabel("Confirm adding/editing the Workout.")
                    .disabled(isDoneButtonDisabled())
                }
            }
            .background(Color(uiColor: .systemGray6))
        }
//        .tint(Color(uiColor: .systemOrange))
    }
    
    private func isDoneButtonDisabled() -> Bool {
        var disableDoneButton = true
        
        if self.editWorkout {
            disableDoneButton = self.workoutManager.workoutsAreEqual(workout1: self.workout, workout2: Workout(workout: self.workoutToCompare)) || isWorkoutEmpty()

        } else {
            disableDoneButton = isWorkoutEmpty()
        }
        
        return disableDoneButton
    }
    
    private func isWorkoutEmpty() -> Bool {
        var isEmpty = self.workout.title.isEmpty
        
        if self.workout.exercises.count > 0 {
            self.workout.exercises.forEach { exercise in
                if exercise.title.isEmpty {
                    isEmpty = true
                }
            }
        } else {
            isEmpty = true
        }
        
        return isEmpty
    }
}

struct AddWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        BaseView()
            .environmentObject(WorkoutManager())
            .environmentObject(DateModel())
            .environmentObject(ViewRouter())
    }
}

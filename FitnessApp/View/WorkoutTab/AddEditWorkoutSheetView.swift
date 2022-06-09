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
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
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
                        Text("Done")
                    }
                    .accessibilityLabel("Confirm adding/editing the Workout.")
                }
            }
            .background(Color(uiColor: .systemGray6))
            .edgesIgnoringSafeArea(.bottom)
        }
//        .tint(Color(uiColor: .systemOrange))
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

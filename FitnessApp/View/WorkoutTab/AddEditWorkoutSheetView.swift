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
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var workout: Workout = Workout()
    var editWorkout: Bool = false
        
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    AEWTitleSectionView(workout: $workout)
                    
                    AEWExerciseSectionView(workout: $workout)
                    
                    AddExerciseButton(workout: $workout)
                }
                .padding(.vertical, 40)
            }
            .navigationTitle("Create new Workout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
                    }
                    .accessibilityLabel("Cancel adding Workout")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        if editWorkout {
                            workoutManager.updateWorkout(workout)
                        } else {
                            workoutManager.addWorkoutToCollection(workout)
                        }
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Done")
                    }
                    .accessibilityLabel("Confirm adding the new Workout")
                }
            }
            .background(Color(uiColor: .systemGray6))
            .edgesIgnoringSafeArea(.bottom)
        }
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

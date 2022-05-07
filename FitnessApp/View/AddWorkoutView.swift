//
//  AddWorkoutView.swift
//  FitnessApp
//
//  Created by Robert Basamac on 07.05.2022.
//

import SwiftUI

struct AddWorkoutView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @EnvironmentObject var dateModel: DateModel
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                WorkoutEditorView(title: "Title", placeholderText: "Add new title", addText: "Add new exercise", list: $workoutManager.workouts)
            }
            .navigationTitle("Create new Workout")
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
                        
                    } label: {
                        Text("Done")
                    }
                    .accessibilityLabel("Confirm adding the new Workout")
                }
            }
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

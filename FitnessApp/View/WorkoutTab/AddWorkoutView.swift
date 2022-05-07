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
    
    @State var newWorkout: Workout = Workout(title: "", description: "", exercises: [Exercise(title: "", type: .repBased, sets: [Set(weight: 0, reps: 0)])])
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $newWorkout.title)
                TextField("Description", text: $newWorkout.description)

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

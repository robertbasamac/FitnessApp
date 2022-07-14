//
//  AssignWorkoutSheetView.swift
//  FitnessApp
//
//  Created by Robert Basamac on 08.06.2022.
//

import SwiftUI

struct AssignWorkoutDatePickerView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @EnvironmentObject var dateModel: DateModel

    @Environment(\.dismiss) private var dismiss

    @State var workout: Workout
    @State private var date: Date = Date()
    
    var body: some View {
        NavigationView {
            VStack {
                DatePicker(selection: $date, in: Date()..., displayedComponents: [.date]) {
                    Text("Select Date")
                }
                .datePickerStyle(GraphicalDatePickerStyle())
                
                Spacer()
            }
            .padding(.horizontal)
            .navigationTitle("Select date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .cancel) {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                    .accessibilityLabel("Cancel assigning the Workout.")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        workoutManager.assignWorkout(workout, for: dateModel.extractDate(date: date, format: "dd/MM/yyy"))
                        dismiss()
                    } label: {
                        Text("Assign")
                    }
                    .accessibilityLabel("Confirm assigning the Workout to the selected Date.")
                }
            }
        }
    }
}

struct AssignWorkoutSheetView_Previews: PreviewProvider {
    static var previews: some View {
        BaseView()
            .environmentObject(WorkoutManager())
            .environmentObject(DateModel())
            .environmentObject(ViewRouter())
    }
}

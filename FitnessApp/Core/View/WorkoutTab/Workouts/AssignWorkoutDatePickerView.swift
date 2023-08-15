//
//  AssignWorkoutSheetView.swift
//  FitnessApp
//
//  Created by Robert Basamac on 08.06.2022.
//

import SwiftUI

struct AssignWorkoutDatePickerView: View {
    @EnvironmentObject var workoutManager: WorkoutViewModel
    @EnvironmentObject var dateModel: DateCalendarViewModel

    @Environment(\.dismiss) private var dismiss

    @State var workout: WorkoutModel
    @State private var date: Date = Date()
    
    var body: some View {
        NavigationView {
            VStack {
                DatePicker("Select Date",
                           selection: $date,
                           in: Date()...,
                           displayedComponents: [.date, .hourAndMinute])
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
                        workoutManager.scheduleWorkout(workout, toDate: date.format("dd/MM/yyy"))
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
            .environmentObject(WorkoutViewModel())
            .environmentObject(DateCalendarViewModel())
            .environmentObject(ViewRouter())
    }
}

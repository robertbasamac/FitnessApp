//
//  WorkoutTabView.swift
//  FitnessApp
//
//  Created by Robert Basamac on 01.05.2022.
//

import SwiftUI

struct WorkoutsTabView: View {
    
    @EnvironmentObject var workoutManager: WorkoutManager
    
    @State private var selectedWorkout: WorkoutModel? = nil
    @State private var assignWorkout: WorkoutModel? = nil
    @State private var selectedWorkoutForDeletion: WorkoutModel? = nil
    
    @State private var editWorkout: Bool = false
    @State private var deleteWorkout: Bool = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            if workoutManager.workouts.isEmpty {
                Text("No workouts found.")
                    .font(.system(size: 16))
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity)
            } else {
                VStack {
                    ForEach($workoutManager.workouts) { workout in
                        WorkoutCardView(workout: workout)
                            .contextMenu {
                                Button {
                                    editWorkout = true
                                    selectedWorkout = workout.wrappedValue
                                } label: {
                                    Label("Edit Workout", systemImage: "pencil")
                                }
                                
                                Button {
                                    assignWorkout = workout.wrappedValue
                                } label: {
                                    Label("Assign Workout", systemImage: "calendar.badge.plus")
                                }
                                
                                Button(role: .destructive) {
                                    deleteWorkout = true
                                    selectedWorkoutForDeletion = workout.wrappedValue
                                } label: {
                                    Label("Delete Workout", systemImage: "trash")
                                }
                            } preview: {
                                Text("\(workout.wrappedValue.title)")
                                    .font(.title2)
                                    .frame(width: 250, alignment: .center)
                                    .padding(.vertical)
                                    .background {
                                        Color(uiColor: .secondarySystemBackground)
                                    }
                            }
                    }
                }
                .padding(.horizontal, 8)
            }
        }
        .sheet(item: $selectedWorkout) { workout in
            CreateWorkoutSheetView(workout: workout, workoutToCompare: workout, editWorkout: $editWorkout)
        }
        .sheet(item: $assignWorkout) { workout in
            AssignWorkoutDatePickerView(workout: workout)
                .presentationDetents([.fraction(0.6)])
                .presentationDragIndicator(.visible)
        }
        .confirmationDialog("Erase Workout from collection.",
                            isPresented: $deleteWorkout,
                            presenting: selectedWorkoutForDeletion) { workout in
            Button(role: .destructive) {
                workoutManager.deleteWorkoutFromCollection(workout)
            } label: {
                Text("Delete")
            }
            
            Button(role: .cancel) {
                selectedWorkoutForDeletion = nil
            } label: {
                Text("Cancel")
            }
        }  message: { workout in
            Text("This will permanently delete the \"\(workout.title)\" workout from your collection.")
        }
    }
}

struct WorkoutTabView_Previews: PreviewProvider {
    static var previews: some View {
        BaseView()
            .environmentObject(WorkoutManager())
            .environmentObject(DateModel())
            .environmentObject(ViewRouter())
    }
}

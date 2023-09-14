//
//  WorkoutTabView.swift
//  FitnessApp
//
//  Created by Robert Basamac on 01.05.2022.
//

import SwiftUI

struct WorkoutsTabView: View {
    
    @EnvironmentObject var workoutManager: WorkoutViewModel
    
    @State private var selectedWorkout: WorkoutModel? = nil
    @State private var workoutToEdit: WorkoutModel? = nil
    @State private var workoutToAssign: WorkoutModel? = nil
    @State private var workoutToDelete: WorkoutModel? = nil
    
    @State private var editWorkout: Bool = false
    @State private var deleteWorkout: Bool = false
    
    @State private var indexSetForDeletion: IndexSet?
    
    var body: some View {
        if workoutManager.workouts.isEmpty {
            Text("No workouts found.")
                .font(.system(size: 16))
                .foregroundStyle(.red)
                .vSpacing(.center)
                .hSpacing(.center)
        } else {
            List {
                ForEach(workoutManager.workouts) { workout in
                    Section {
                        WorkoutCard(workout: workout)
                            .swipeActions(edge: .leading, allowsFullSwipe: false, content: {
                                Button {
                                    workoutToAssign = workout
                                } label: {
                                    Label("Assign Workout", systemImage: "calendar")
                                }
                                .tint(.orange)
                            })
                            .swipeActions(edge: .trailing, allowsFullSwipe: true, content: {
                                Button(role: .destructive) {
                                    deleteWorkout = true
                                    workoutToDelete = workout
                                } label: {
                                    Label("Delete Workout", systemImage: "trash")
                                }
                            })
                            .contextMenu {
                                // Edit Button
                                Button {
                                    editWorkout = true
                                    workoutToEdit = workout
                                } label: {
                                    Label("Edit Workout", systemImage: "pencil")
                                }
                                
                                // Assign Button
                                Button {
                                    workoutToAssign = workout
                                } label: {
                                    Label("Assign Workout", systemImage: "calendar.badge.plus")
                                }
                                
                                // Delete Button
                                Button(role: .destructive) {
                                    deleteWorkout = true
                                    workoutToDelete = workout
                                } label: {
                                    Label("Delete Workout", systemImage: "trash")
                                }
                            }
                            .onTapGesture {
                                selectedWorkout = workout
                            }
                    }
                }
            }
            .listSectionSpacing(.compact)
            .navigationDestination(item: $selectedWorkout, destination: { workout in
                Text(workout.title.uppercased())
            })
            .sheet(item: $workoutToEdit) { workout in
                CreateWorkoutSheetView(workout: workout, editWorkout: $editWorkout)
                    .interactiveDismissDisabled()
            }
            .sheet(item: $workoutToAssign) { workout in
                AssignWorkoutDatePickerView(workout: workout)
                    .presentationDetents([.fraction(0.6)])
                    .presentationDragIndicator(.visible)
            }
            .confirmationDialog("Erase Workout from collection.",
                                isPresented: $deleteWorkout,
                                presenting: workoutToDelete) { workout in
                Button(role: .destructive) {
                    workoutManager.deleteWorkoutFromCollection(workout)
                } label: {
                    Text("Delete")
                }
                
                Button(role: .cancel) {
                    deleteWorkout = false
                    workoutToDelete = nil
                } label: {
                    Text("Cancel")
                }
            }  message: { workout in
                Text("This will permanently delete the \"\(workout.title)\" workout from your collection.")
            }
        }
    }
}

struct WorkoutTabView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionTabView()
            .environmentObject(WorkoutViewModel())
            .environmentObject(DateCalendarViewModel())
            .environmentObject(ViewRouter())
    }
}

//
//  WorkoutTabView.swift
//  FitnessApp
//
//  Created by Robert Basamac on 01.05.2022.
//

import SwiftUI

struct WorkoutTabView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @EnvironmentObject var dateModel: DateModel
    
    @State private var selectedWorkout: Workout? = nil
    @State private var editWorkout: Bool = false
    
    @State private var assignWorkout: Workout? = nil
    
    @State private var workoutToBeDeleted: Workout? = nil
    @State private var isDeletingWorkout: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                if workoutManager.workouts.count > 0 {
                    ForEach($workoutManager.workouts) { workout in
                        WorkoutCardView(workout: workout)
                            .contextMenu {
                                Button {
                                    editWorkout = true
                                    selectedWorkout = workout.wrappedValue
                                } label: {
                                    Label("Edit Workout", systemImage: "square.and.pencil")
                                }
                                
                                Button {
                                    assignWorkout = workout.wrappedValue
                                } label: {
                                    Label("Assign Workout", systemImage: "calendar.badge.plus")
                                }
                                
                                Button(role: .destructive) {
                                    isDeletingWorkout = true
                                    workoutToBeDeleted = workout.wrappedValue
                                } label: {
                                    Label("Delete Workout", systemImage: "trash")
                                }
                            } preview: {
                                Text("\(workout.wrappedValue.title)")
                                    .font(.title)
                                    .padding(.all)
                                    .background {
                                        Color(uiColor: .secondarySystemBackground)
                                    }
                            }
                    }
                } else {
                    Text("No workouts found.")
                        .font(.system(size: 16))
                        .foregroundColor(.red)
                }
            }
            .navigationTitle("Workouts")
            .navigationViewStyle(StackNavigationViewStyle())
            .toolbar {
                Button {
                    editWorkout = false
                    selectedWorkout = Workout()
                } label: {
                    Image(systemName: "plus")
                }
                .accessibilityLabel("Add new Workout")
            }
            .sheet(item: $selectedWorkout) { selectedWorkout in
                AddEditWorkoutSheetView(workout: selectedWorkout, editWorkout: $editWorkout)
            }
            .sheet(item: $assignWorkout) { selectedWorkout in
                AssignWorkoutDatePickerView(workout: selectedWorkout)
                    .presentationDetents([.fraction(0.6)])
            }
            .confirmationDialog(
                Text("Pernanently erase the workout from your workout collection?"),
                isPresented: $isDeletingWorkout,
                presenting: workoutToBeDeleted) { workout in
                    Button(role: .destructive) {
                        workoutManager.removeWorkoutFromCollection(workout)
                    } label: {
                        Text("Delete")
                    }
                    Button("Cancel", role: .cancel) {
                        workoutToBeDeleted = nil
                    }
                }  message: { workout in
                    Text("This will permanently delete the \"\(workout.title)\" workout from your collection.")
                }
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

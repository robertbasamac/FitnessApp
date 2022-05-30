//
//  WorkoutTabView.swift
//  FitnessApp
//
//  Created by Robert Basamac on 01.05.2022.
//

import SwiftUI
import SheeKit

struct WorkoutTabView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @EnvironmentObject var dateModel: DateModel
    
    @State private var selectedWorkout: Workout? = nil
    @State private var editWorkout: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
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
                                
                                Button(role: .destructive) {
                                    workoutManager.removeWorkoutFromCollection(workout.wrappedValue)
                                } label: {
                                    Label("Delete Workout", systemImage: "trash")
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
                AddEditWorkoutSheetView(workout: selectedWorkout, editWorkout: editWorkout)
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

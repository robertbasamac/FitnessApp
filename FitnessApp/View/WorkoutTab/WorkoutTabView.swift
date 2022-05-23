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
    
    @State private var isShowingAddWorkoutSheet = false
    
    @State private var selectedWorkout: Workout? = nil
    
    var body: some View {
        NavigationView {
            ScrollView {
                let workouts = workoutManager.getAllWorkoutsFromCollection()
                if workouts.count > 0 {
                    ForEach(workouts) { workout in
                        WorkoutCardView(workout: workout)
                            .contextMenu {
                                Button {
                                    selectedWorkout = workout
                                } label: {
                                    Label("Edit Workout", systemImage: "square.and.pencil")
                                }
                                
                                Button(role: .destructive) {
                                    workoutManager.removeWorkoutFromCollection(workout)
                                } label: {
                                    Label("Delete Workout", systemImage: "trash")
                                }
                            }
                    }
                    .sheet(item: self.$selectedWorkout) { selectedWorkout in
                        AddEditWorkoutSheetView(workout: selectedWorkout, editWorkout: true)
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
                    isShowingAddWorkoutSheet.toggle()
                } label: {
                    Image(systemName: "plus")
                }
                .accessibilityLabel("Add new Workout")
            }
            .sheet(isPresented: $isShowingAddWorkoutSheet) {
                AddEditWorkoutSheetView()
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

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
    
    // Handling delete action
//    @State private var workoutToDelete: WorkoutModel? = nil
    @State private var showDeleteConfirmation: Bool = false
        
    // Handling sheets presentation
    enum Sheet: String, Identifiable {
        case editWorkout, assignWorkout
        
        var id: String { rawValue }
    }
    @State private var selectedWorkoutForAction: WorkoutModel = WorkoutModel()
    @State private var presentedSheet: Sheet?
    
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
                                // Swipe right action - Assign Workout
                                Button {
                                    selectedWorkoutForAction = workout
                                    presentedSheet = .assignWorkout
                                } label: {
                                    Label("Assign Workout", systemImage: "calendar")
                                }
                                .tint(.orange)
                            })
                            .swipeActions(edge: .trailing, allowsFullSwipe: true, content: {
                                // Swipe left action - Delete Workout
                                Button(role: .destructive) {
                                    selectedWorkoutForAction = workout
                                    showDeleteConfirmation = true
                                } label: {
                                    Label("Delete Workout", systemImage: "trash")
                                }
                            })
                            .contextMenu {
                                // Edit Button
                                Button {
                                    selectedWorkoutForAction = workout
                                    presentedSheet = .editWorkout
                                } label: {
                                    Label("Edit Workout", systemImage: "pencil")
                                }
                                
                                // Assign Button
                                Button {
                                    selectedWorkoutForAction = workout
                                    presentedSheet = .assignWorkout
                                } label: {
                                    Label("Assign Workout", systemImage: "calendar.badge.plus")
                                }
                                
                                // Delete Button
                                Button(role: .destructive) {
                                    selectedWorkoutForAction = workout
                                    showDeleteConfirmation = true
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
                DetailWorkoutView(workout: workout)
            })
            .sheet(item: $presentedSheet) { sheet in
                switch sheet {
                case .editWorkout:
                    CreateWorkoutSheetView(workout: selectedWorkoutForAction, editWorkout: true)
                        .interactiveDismissDisabled()
                case .assignWorkout:
                    AssignWorkoutDatePickerView(workout: selectedWorkoutForAction)
                        .presentationDetents([.fraction(0.6)])
                        .presentationDragIndicator(.visible)
                }
            }
            .confirmationDialog("Erase Workout from collection.",
                                isPresented: $showDeleteConfirmation,
                                presenting: selectedWorkoutForAction) { workout in
                Button(role: .destructive) {
                    workoutManager.deleteWorkoutFromCollection(workout)
                } label: {
                    Text("Delete")
                }
                
                Button(role: .cancel) {
                    showDeleteConfirmation = false
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

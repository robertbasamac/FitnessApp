//
//  ExercisesTabView.swift
//  FitnessApp
//
//  Created by Robert Basamac on 15.07.2022.
//

import SwiftUI

struct ExercisesTabView: View {
    
    @EnvironmentObject var workoutManager: WorkoutViewModel

    @State private var selectedExercise: ExerciseModel? = nil
    @State private var selectedExerciseForAction: ExerciseModel = ExerciseModel()
    
    @State private var editExercise: Bool = false
    @State private var showDeleteConfirmation: Bool = false
    
    var body: some View {
        if workoutManager.exercises.isEmpty {
            Text("No exercises found.")
                .font(.system(size: 16))
                .foregroundColor(.red)
                .vSpacing(.center)
                .hSpacing(.center)
        } else {
            List {
                ForEach(workoutManager.exercises) { exercise in
                    Section {
                        ExerciseCard(exercise: exercise)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true, content: {
                                Button(role: .destructive) {
                                    selectedExerciseForAction = exercise
                                    showDeleteConfirmation = true
                                } label: {
                                    Label("Delete Exercise", systemImage: "trash")
                                }
                            })
                            .contextMenu {
                                Button {
                                    selectedExerciseForAction = exercise
                                    editExercise = true
                                } label: {
                                    Label("Edit Exercise", systemImage: "pencil")
                                }
                                
                                Button(role: .destructive) {
                                    selectedExerciseForAction = exercise
                                    showDeleteConfirmation = true
                                } label: {
                                    Label("Delete Exercise", systemImage: "trash")
                                }
                            }
                    }
                    .listSectionSpacing(.compact)
                }
            }
            .sheet(isPresented: $editExercise) {
                CreateExerciseSheetView(exercise: selectedExerciseForAction, editExercise: true)
                    .interactiveDismissDisabled()
            }
            .confirmationDialog("Erase Exercise from collection.",
                                isPresented: $showDeleteConfirmation,
                                presenting: selectedExerciseForAction) { exercise in
                Button(role: .destructive) {
                    workoutManager.deleteExerciseFromCollection(exercise)
                } label: {
                    Text("Delete")
                }
                
                Button(role: .cancel) {
                    showDeleteConfirmation = false
                } label: {
                    Text("Cancel")
                }
            }  message: { exercise in
                Text("This will permanently delete the \"\(exercise.title)\" exercise from your collection.")
            }
        }
    }
}

struct ExercisesTabView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionTabView()
            .environmentObject(WorkoutViewModel())
            .environmentObject(DateCalendarViewModel())
            .environmentObject(ViewRouter())
    }
}

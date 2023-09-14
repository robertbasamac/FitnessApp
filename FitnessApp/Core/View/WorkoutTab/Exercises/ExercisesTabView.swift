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
    @State private var selectedExerciseForDeletion: ExerciseModel? = nil

    @State private var editExercise: Bool = false
    @State private var deleteExercise: Bool = false

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
                                    deleteExercise = true
                                    selectedExerciseForDeletion = exercise
                                } label: {
                                    Label("Delete Exercise", systemImage: "trash")
                                }
                            })
                            .contextMenu {
                                Button {
                                    editExercise = true
                                    selectedExercise = exercise
                                } label: {
                                    Label("Edit Exercise", systemImage: "pencil")
                                }
                                
                                Button(role: .destructive) {
                                    deleteExercise = true
                                    selectedExerciseForDeletion = exercise
                                } label: {
                                    Label("Delete Exercise", systemImage: "trash")
                                }
                            }
                    }
                    .listSectionSpacing(.compact)
                }
            }
            .sheet(item: $selectedExercise) { exercise in
                CreateExerciseSheetView(exercise: exercise, exerciseToCompare: exercise, editExercise: $editExercise)
            }
            .confirmationDialog("Erase Exercise from collection.",
                                isPresented: $deleteExercise,
                                presenting: selectedExerciseForDeletion) { exercise in
                Button(role: .destructive) {
                    workoutManager.deleteExerciseFromCollection(exercise)
                } label: {
                    Text("Delete")
                }
                
                Button(role: .cancel) {
                    selectedExerciseForDeletion = nil
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

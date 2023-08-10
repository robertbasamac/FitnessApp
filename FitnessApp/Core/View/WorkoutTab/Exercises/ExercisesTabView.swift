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
        ScrollView(.vertical, showsIndicators: true) {
            if workoutManager.exercises.isEmpty {
                Text("No exercises found.")
                    .font(.system(size: 16))
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity)
            } else {
                VStack {
                    ForEach($workoutManager.exercises) { exercise in
                        ExerciseCardView(exercise: exercise)
                            .frame(maxWidth: .infinity)
                            .contextMenu {
                                Button {
                                    editExercise = true
                                    selectedExercise = exercise.wrappedValue
                                } label: {
                                    Label("Edit Exercise", systemImage: "pencil")
                                }

                                Button(role: .destructive) {
                                    deleteExercise = true
                                    selectedExerciseForDeletion = exercise.wrappedValue
                                } label: {
                                    Label("Delete Exercise", systemImage: "trash")
                                }
                            } preview: {
                                Text("\(exercise.wrappedValue.title)")
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

struct ExercisesTabView_Previews: PreviewProvider {
    static var previews: some View {
        ExercisesTabView()
    }
}

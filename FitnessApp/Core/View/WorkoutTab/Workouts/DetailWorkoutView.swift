//
//  DetailWorkoutView.swift
//  FitnessApp
//
//  Created by Robert Basamac on 18.09.2023.
//

import SwiftUI

struct DetailWorkoutView: View {
    @EnvironmentObject var workoutManager: WorkoutViewModel
    
    @State var workout: WorkoutModel
    
    @State private var editWorkout: Bool = false
    
    init(workout: WorkoutModel) {
        self._workout = State(wrappedValue: workout)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if !workout.details.isEmpty {
                Text(workout.details)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .hSpacing(.leading)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 6)
                
                Divider()
            }
            
            List {
                ForEach(workout.exercises.indices, id: \.self) { exerciseIndex in
                    // Exercise
                    Section {
                        VStack {
                            // Title and exercise index
                            HStack {
                                Text("\(workout.exercises[exerciseIndex].title)")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.orange)
                                
                                Spacer()
                                
                                Text("\(exerciseIndex + 1)")
                                    .font(.subheadline)
                                    .padding(.horizontal, 8)
                                    .background {
                                        Circle()
                                            .stroke(lineWidth: 2)
                                            .frame(width: 20, height: 20)
                                    }
                            }
                            
                            // Instructions
                            if !workout.exercises[exerciseIndex].instructions.isEmpty {
                                Text(workout.exercises[exerciseIndex].instructions)
                                    .font(.callout)
                                    .foregroundStyle(.secondary)
                                    .hSpacing(.leading)
                            }
                                                        
                            // Sets
                            if editWorkout {
                                SetsSectionEditMode(forExerciseIndex: exerciseIndex)
                            } else {
                                SetsSection(forExerciseIndex: exerciseIndex)
                            }
                        }
                    }
                }
            }
            .listSectionSpacing(.compact)
        }
        .navigationTitle(workout.title)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button {
                        editWorkout.toggle()
                } label: {
                    if editWorkout {
                        Text("Cancel")
                    } else {
                        Text("Edit")
                    }
                }
            }
            
            if editWorkout {
                ToolbarItem(placement: .automatic) {
                    Button {
                        workoutManager.updateWorkout(workout)
                        editWorkout.toggle()
                    } label: {
                        Text("Save")
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func SetsSection(forExerciseIndex exerciseIndex: Int) -> some View {
        HStack {
            Text("#")
                .padding(.leading, 12)
                .hSpacing(.leading)
            
            if workout.exercises[exerciseIndex].type == .repBased {
                Text("Reps")
                    .frame(width: 60)
            } else {
                Text("Duration")
                    .frame(width: 60)
            }
            Text("Weight")
                .frame(width: 80)
            Text("Rest")
                .frame(width: 60)
        }
        .font(.caption)
        .padding(.top, 4)
        
        ForEach(workout.exercises[exerciseIndex].sets.indices, id: \.self) { setIndex in
            Divider()
            HStack {
                Text("\(setIndex + 1)")
                    .padding(.leading, 12)
                    .hSpacing(.leading)
                
                if workout.exercises[exerciseIndex].type == .repBased {
                    Text("\(workout.exercises[exerciseIndex].sets[setIndex].reps)")
                        .frame(width: 60)
                } else {
                    Text("\(workout.exercises[exerciseIndex].sets[setIndex].duration) s")
                        .frame(width: 60)
                }
                
                Text("\(workout.exercises[exerciseIndex].sets[setIndex].weight, specifier: "%.1f") Kg")
                    .frame(width: 80)
                
                Text("\(workout.exercises[exerciseIndex].sets[setIndex].duration) s")
                    .frame(width: 60)
            }
            .font(.subheadline)
            .frame(height: 22)
        }
    }
    
    @ViewBuilder
    private func SetsSectionEditMode(forExerciseIndex exerciseIndex: Int) -> some View {
        HStack {
            Text("#")
                .padding(.leading, 12)
                .hSpacing(.leading)
            
            if workout.exercises[exerciseIndex].type == .repBased {
                Text("Reps")
                    .frame(width: 60)
            } else {
                Text("Duration")
                    .frame(width: 60)
            }
            Text("Weight")
                .frame(width: 80)
            Text("Rest")
                .frame(width: 60)
        }
        .font(.caption)
        .padding(.top, 4)
        
        ForEach(workout.exercises[exerciseIndex].sets.indices, id: \.self) { setIndex in
            Divider()
            HStack {
                Text("\(setIndex + 1)")
                    .padding(.leading, 12)
                    .hSpacing(.leading)
                
                if workout.exercises[exerciseIndex].type == .repBased {
                    TextField("Reps", value: $workout.exercises[exerciseIndex].sets[setIndex].reps, formatter: NumberFormatter())
                        .keyboardType(.numberPad)
                        .submitLabel(.done)
                        .multilineTextAlignment(.center)
                        .frame(width: 60)
                        .background {
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundColor(Color.gray.opacity(0.6))
                        }
                } else {
                    TextField("Duration", value: $workout.exercises[exerciseIndex].sets[setIndex].duration, formatter: NumberFormatter())
                        .keyboardType(.decimalPad)
                        .submitLabel(.done)
                        .multilineTextAlignment(.center)
                        .frame(width: 60)
                        .background {
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundColor(Color.gray.opacity(0.6))
                        }
                }
                
                TextField("Weight", value: $workout.exercises[exerciseIndex].sets[setIndex].weight, formatter: NumberFormatter())
                    .keyboardType(.decimalPad)
                    .submitLabel(.next)
                    .multilineTextAlignment(.center)
                    .frame(width: 80)
                    .background {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(Color.gray.opacity(0.6))
                    }
                
                TextField("Rest", value: $workout.exercises[exerciseIndex].sets[setIndex].rest, formatter: NumberFormatter())
                    .keyboardType(.decimalPad)
                    .submitLabel(.done)
                    .multilineTextAlignment(.center)
                    .frame(width: 60)
                    .background {
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundColor(Color.gray.opacity(0.6))
                    }
            }
            .font(.subheadline)
            .frame(height: 22)
        }
    }
}

#Preview {
    NavigationStack {
        DetailWorkoutView(workout: WorkoutModel(title: "Push day like no other",
                                                details: "This workout will focus the upper body mostly, but it will target the lower body, especially the core, to perform the movements.",
                                                exercises: [ExerciseModel(title: "Push ups",
                                                                          instructions: "Come on.. do a fucking push ups! Come a on.. do a fucking push ups! Come on.. do a fucking push ups! Come on.. do a fucking push ups!",
                                                                          type: .repBased,
                                                                          sets: [SetModel(weight: 5, duration: 60, rest: 60, reps: 20),
                                                                                 SetModel(weight: 10, duration: 120, rest: 60, reps: 15),
                                                                                 SetModel(weight: 20, duration: 180, rest: 60, reps: 10),
                                                                                ]),
                                                            ExerciseModel(title: "Pull ups",
                                                                          instructions: "Come on.. do a fucking pull ups!",
                                                                          type: .timeBased,
                                                                          sets: [SetModel(weight: 0, duration: 0, rest: 60, reps: 12),
                                                                                 SetModel(weight: 0, duration: 0, rest: 60, reps: 10),
                                                                                 SetModel(weight: 0, duration: 0, rest: 60, reps: 8),
                                                                                ]),
                                                            ExerciseModel(title: "Push ups",
                                                                          instructions: "Come on.. do a fucking push ups!",
                                                                          type: .repBased,
                                                                          sets: [SetModel(weight: 5, duration: 0, rest: 60, reps: 20),
                                                                                 SetModel(weight: 10, duration: 0, rest: 60, reps: 15),
                                                                                 SetModel(weight: 15, duration: 0, rest: 60, reps: 10),
                                                                                ]),
                                                            ExerciseModel(title: "Pull ups",
                                                                          instructions: "Come on.. do a fucking pull ups!",
                                                                          type: .repBased,
                                                                          sets: [SetModel(weight: 0, duration: 0, rest: 60, reps: 12),
                                                                                 SetModel(weight: 0, duration: 0, rest: 60, reps: 10),
                                                                                 SetModel(weight: 0, duration: 0, rest: 60, reps: 8),
                                                                                ]),
                                                            ExerciseModel(title: "Push ups",
                                                                          instructions: "Come on.. do a fucking push ups!",
                                                                          type: .repBased,
                                                                          sets: [SetModel(weight: 0, duration: 0, rest: 60, reps: 20),
                                                                                 SetModel(weight: 0, duration: 0, rest: 60, reps: 15),
                                                                                 SetModel(weight: 0, duration: 0, rest: 60, reps: 10),
                                                                                ]),
                                                            ExerciseModel(title: "Pull ups",
                                                                          instructions: "Come on.. do a fucking pull ups!",
                                                                          type: .repBased,
                                                                          sets: [SetModel(weight: 0, duration: 0, rest: 60, reps: 12),
                                                                                 SetModel(weight: 0, duration: 0, rest: 60, reps: 10),
                                                                                 SetModel(weight: 0, duration: 0, rest: 60, reps: 8),
                                                                                ])
                                                ]))
    }
}

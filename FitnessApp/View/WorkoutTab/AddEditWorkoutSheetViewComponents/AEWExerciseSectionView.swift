//
//  ExerciseView.swift
//  FitnessApp
//
//  Created by Robert Basamac on 11.05.2022.
//

import SwiftUI

struct AEWExerciseSectionView: View {
    @Binding var workout: Workout
    
    var body: some View {
        ForEach(workout.exercises.indices, id: \.self) { exerciseIndex in
            VStack(spacing: 0) {
                Divider()
                    .background(Color(uiColor: .systemGray))
                
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        RemoveExerciseButton(workout: $workout, index: exerciseIndex)
                        
                        VStack(spacing: 0) {
                            TextField("Title", text: $workout.exercises[exerciseIndex].title)
                                .frame(height: 40)
                            
                            Divider()
                                .background(Color(uiColor: .systemGray))
                            
                            HStack(spacing: 20){
                                Text("Type")
                                    .frame(height: 40)
                                
                                Picker("Type", selection: $workout.exercises[exerciseIndex].type) {
                                    ForEach(ExerciseType.allCases, id: \.self) { value in
                                        Text(value.rawValue)
                                            .tag(value)
                                    }
                                }
                                .pickerStyle(.segmented)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    Divider()
                        .background(Color(uiColor: .systemGray))
                    
                    AEWSetSectionView(exercise: $workout.exercises[exerciseIndex])
                    
                    AddSetButton(exercise: $workout.exercises[exerciseIndex])
                }
                .padding(.leading, 20)
                .background(Color(uiColor: .tertiarySystemBackground))
                
                Divider()
                    .background(Color(uiColor: .systemGray))
            }
            .padding(.bottom, 40)
        }
    }
}

struct AddExerciseButton: View {
    @Binding var workout: Workout
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .background(Color(uiColor: .systemGray))

            Button {
                workout.exercises.append(Exercise())
            } label: {
                HStack(spacing: 20) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.green)
                        .background {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 10, height: 10)
                        }
                    Text("add exercise")
                }
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity, minHeight: 40, alignment: .leading)
                .background(Color(uiColor: .tertiarySystemBackground))
            }
            
            Divider()
                .background(Color(uiColor: .systemGray))
        }
        .padding(.bottom, 40)
    }
}

struct RemoveExerciseButton: View {
    @Binding var workout: Workout
    
    let index: Int
    
    var body: some View {
        Button {
            workout.exercises.remove(at: index)
        } label: {
            Image(systemName: "minus.circle.fill")
                .foregroundColor(.red)
                .background {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 10, height: 10)
                }
        }
    }
}

struct ExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        BaseView()
            .environmentObject(WorkoutManager())
            .environmentObject(DateModel())
            .environmentObject(ViewRouter())
    }
}

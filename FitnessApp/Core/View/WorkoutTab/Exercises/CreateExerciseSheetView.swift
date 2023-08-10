//
//  CreateExerciseSheetView.swift
//  FitnessApp
//
//  Created by Robert Basamac on 14.07.2022.
//

import SwiftUI

struct CreateExerciseSheetView: View {
    @EnvironmentObject var workoutManager: WorkoutViewModel
    @EnvironmentObject var dateModel: DateCalendarViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    @State var exercise: ExerciseModel = ExerciseModel()
    
    var exerciseToCompare: ExerciseModel = ExerciseModel()
    
    @Binding var editExercise: Bool
    
    @State var scrollToIndex: Int = 0
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        Spacer()
                            .frame(height: 40)
                        
                        titleSection
                        
                        setsSection
                        
                        Spacer()
                            .frame(height: 40)
                        
                        addSetButton
                        
                        Spacer()
                            .frame(height: 40)
                    }
                    .onChange(of: scrollToIndex) { newValue in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation {
                                proxy.scrollTo(newValue, anchor: .top)
                            }
                        }
                    }
                }
            }
            .navigationTitle(editExercise ? "Edit Exercise" : "Create Exercise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .cancel) {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                    .accessibilityLabel("Cancel adding/editing the Exercise.")
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        if editExercise {
                            workoutManager.updateExercise(exercise)
                        } else {
                            workoutManager.addExerciseToCollection(exercise: exercise)
                        }
                        
                        dismiss()
                    } label: {
                        Text(editExercise ? "Save" : "Add")
                    }
                    .accessibilityLabel("Confirm adding/editing the Exercise.")
                    .disabled(isDoneButtonDisabled())
                }
            }
            .background(Color(uiColor: .secondarySystemBackground))
        }
    }
}

//MARK: - Content Views
extension CreateExerciseSheetView {
    
    private var titleSection: some View {
        
        VStack(spacing: 0) {
            Divider()
                .background(Color(uiColor: .systemGray))
            
            VStack(spacing: 0) {
                TextField("Title", text: $exercise.title)
                    .frame(height: 40)
                
                Divider()
                    .background(Color(uiColor: .systemGray))
                
                TextField("Instructions", text: $exercise.instructions)
                    .padding(.trailing, 20)
                    .frame(height: 40)
                    .font(.system(size: 16))
                    .foregroundStyle(.secondary)
                
                Divider()
                    .background(Color(uiColor: .systemGray))
                
                HStack(spacing: 20){
                    Text("Type")
                        .frame(height: 40)
                    
                    Spacer()
                    
                    Picker("Type", selection: $exercise.type) {
                        ForEach(ExerciseType.allCases, id: \.self) { value in
                            Text(value.rawValue)
                                .tag(value)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .padding(.horizontal, 20)
            
            Divider()
                .background(Color(uiColor: .systemGray))
        }
        .id(-10)
        .background(Color(uiColor: .tertiarySystemBackground))
    }
    
    private var setsSection: some View {
        
        ForEach(exercise.sets.indices, id: \.self) { setIndex in
            ZStack(alignment: .bottom) {
                Spacer()
                    .frame(height: 40)
                
                Text("Set \(setIndex + 1)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 6)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            VStack(spacing: 0) {
                Divider()
                    .background(Color(uiColor: .systemGray))
                
                HStack(spacing: 0) {
                    removeSetButton(setIndex: setIndex)
                    
                    VStack(spacing: 0) {
                        if exercise.type == .repBased {
                            Stepper(value: $exercise.sets[setIndex].reps, in: 1...Int.max, step: 1) {
                                Text("\(exercise.sets[setIndex].reps) rep(s)")
                                    .frame(height: 40)
                            }
                        } else {
                            Stepper(value: $exercise.sets[setIndex].duration, in: 1...Int.max, step: 1) {
                                Text("Work: \(exercise.sets[setIndex].duration) second(s)")
                                    .frame(height: 40)
                            }
                        }
                        
                        Divider()
                            .background(Color(uiColor: .systemGray))
                        
                        adjustWeightSection(setIndex: setIndex)
                        
                        Divider()
                            .background(Color(uiColor: .systemGray))
                        
                        Stepper(value: $exercise.sets[setIndex].rest, in: 0...Int.max, step: 1) {
                            Text("Recovery: \(exercise.sets[setIndex].rest) second(s)")
                                .frame(height: 40)
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.leading, 20)
                
                Divider()
                    .background(Color(uiColor: .systemGray))
            }
            .id(setIndex * 10)
            .background(Color(uiColor: .tertiarySystemBackground))
        }
    }
    
    private func adjustWeightSection(setIndex: Int) -> some View {
        
        HStack(spacing: 20) {
            VStack(alignment: .center, spacing: 15) {
                Text("Weight")
                Text(String(format: "%.1f", exercise.sets[setIndex].weight))
                Text("Kg")
            }
            
            VStack(spacing: 5) {
                Stepper(value: $exercise.sets[setIndex].weight, in: 0...999, step: 20) {
                    HStack(spacing: 0) {
                        Spacer()
                        Text("20 Kg")
                    }
                }
                Stepper(value: $exercise.sets[setIndex].weight, in: 0...999, step: 10) {
                    HStack(spacing: 0) {
                        Spacer()
                        Text("10 Kg")
                    }
                }
                Stepper(value: $exercise.sets[setIndex].weight, in: 0...999, step: 5) {
                    HStack(spacing: 0) {
                        Spacer()
                        Text("5 Kg")
                    }
                }
                Stepper(value: $exercise.sets[setIndex].weight, in: 0...999, step: 2.5) {
                    HStack(spacing: 0) {
                        Spacer()
                        Text("2.5 Kg")
                    }
                }
                Stepper(value: $exercise.sets[setIndex].weight, in: 0...999, step: 0.5) {
                    HStack(spacing: 0) {
                        Spacer()
                        Text("0.5 Kg")
                    }
                }
            }
        }
        .padding(.vertical, 5)
    }
    
}

//MARK: - Add and Remove buttons
extension CreateExerciseSheetView {
    
    private var addSetButton: some View {
        
        VStack(spacing: 0) {
            Divider()
                .background(Color(uiColor: .systemGray))
            
            Button {
                withAnimation {
                    exercise.sets.append(SetModel())
                }
                
                scrollToIndex = (exercise.sets.count - 1) * 10
            } label: {
                HStack(spacing: 20) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.green)
                        .background {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 10, height: 10)
                        }
                    Text("add set")
                }
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity, minHeight: 40, alignment: .leading)
                .background(Color(uiColor: .tertiarySystemBackground))
            }
            
            Divider()
                .background(Color(uiColor: .systemGray))
        }
    }
    
    private func removeSetButton(setIndex: Int) -> some View {
        
        Button {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            
            exercise.sets.remove(at: setIndex)
        } label: {
            HStack(spacing: 0) {
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
}

//MARK: - Helper methods
extension CreateExerciseSheetView {
    
    private func isDoneButtonDisabled() -> Bool {
        var disableDoneButton = true
        
        if editExercise {
            disableDoneButton = workoutManager.exercisesAreEqual(exercise1: exercise, exercise2: exerciseToCompare) || isExerciseEmpty()

        } else {
            disableDoneButton = isExerciseEmpty()
        }
        
        return disableDoneButton
    }
    
    private func isExerciseEmpty() -> Bool {
        return exercise.title.isEmpty
    }
}

//MARK: - Preview
struct CreateExerciseSheetView_Previews: PreviewProvider {
    static var previews: some View {
        BaseView()
            .environmentObject(WorkoutViewModel())
            .environmentObject(DateCalendarViewModel())
            .environmentObject(ViewRouter())
    }
}

//
//  AddWorkoutView.swift
//  FitnessApp
//
//  Created by Robert Basamac on 07.05.2022.
//

import SwiftUI

struct CreateWorkoutSheetView: View {
    @EnvironmentObject var workoutManager: WorkoutViewModel
    @EnvironmentObject var dateModel: DateCalendarViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    @State var workout: WorkoutModel
    var workoutToCompare: WorkoutModel
    var editWorkout: Bool
    
    @State var scrollToIndex: Int = 0
    
    init(workout: WorkoutModel = WorkoutModel(), editWorkout: Bool = false) {
        self._workout = State(wrappedValue: workout)
        self.workoutToCompare = workout
        self.editWorkout = editWorkout
        self.scrollToIndex = scrollToIndex
    }
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        Spacer()
                            .frame(height: 40)
                        
                        titleSection
                        
                        exercisesAndSetsSection
                        
                        Spacer()
                            .frame(height: 40)

                        addExerciseButton()
                        
                        Spacer()
                            .frame(height: 40)
                    }
                    .onChange(of: scrollToIndex, { oldValue, newValue in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation {
                                proxy.scrollTo(newValue, anchor: .top)
                            }
                        }
                    })
                }
            }
            .navigationTitle(editWorkout ? "Edit Workout" : "Create new Workout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(role: .cancel) {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                    .accessibilityLabel("Cancel adding/editing the Workout.")
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        if editWorkout {
                            workoutManager.updateWorkout(workout)
                        } else {
                            workoutManager.addWorkoutToCollection(workout: workout)
                        }
                        
                        dismiss()
                    } label: {
                        Text(editWorkout ? "Save" : "Add")
                    }
                    .accessibilityLabel("Confirm adding/editing the Workout.")
                    .disabled(isDoneButtonDisabled())
                }
            }
            .background(Color(uiColor: .secondarySystemBackground))
        }
    }
}

//MARK: - Content Views
extension CreateWorkoutSheetView {
    
    private var titleSection: some View {
        
        VStack(spacing: 0) {
            Divider()
                .background(Color(uiColor: .systemGray))
            
            VStack(spacing: 0) {
                TextField("Title", text: $workout.title)
                    .padding(.trailing, 20)
                    .frame(height: 40)
                
                Divider()
                    .background(Color(uiColor: .systemGray))
                
                TextField("Description", text: $workout.details)
                    .padding(.trailing, 20)
                    .frame(height: 40)
                    .font(.system(size: 16))
                    .foregroundStyle(.secondary)
            }
            .padding(.leading, 20)
            
            Divider()
                .background(Color(uiColor: .systemGray))
        }
        .id(-10)
        .background(Color(uiColor: .tertiarySystemBackground))
    }
    
    private var exercisesAndSetsSection: some View {
        
        ForEach(workout.exercises.indices, id: \.self) { exerciseIndex in
            ZStack(alignment: .bottom) {
                Spacer()
                    .frame(height: 40)
                
                Text("Exercise \(exerciseIndex + 1)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 6)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
            }
            
            VStack(spacing: 0) {
                Divider()
                    .background(Color(uiColor: .systemGray))
                
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        removeExerciseButton(index: exerciseIndex)
                        
                        VStack(spacing: 0) {
                            TextField("Title", text: $workout.exercises[exerciseIndex].title)
                                .frame(height: 40)
                            
                            Divider()
                                .background(Color(uiColor: .systemGray))
                            
                            TextField("Instructions", text: $workout.exercises[exerciseIndex].instructions)
                                .padding(.trailing, 20)
                                .frame(height: 40)
                                .font(.system(size: 16))
                                .foregroundStyle(.secondary)
                            
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
                    
                    setsSection(index: exerciseIndex)
                    
                    addSetButton(index: exerciseIndex)
                }
                .padding(.leading, 20)
                
                Divider()
                    .background(Color(uiColor: .systemGray))
            }
            .id(exerciseIndex * 10)
            .background(Color(uiColor: .tertiarySystemBackground))
        }
    }
    
    private func setsSection(index: Int) -> some View {
        
        ForEach(workout.exercises[index].sets.indices, id: \.self) { setIndex in
            HStack(spacing: 0) {
                HStack(spacing: 20) {
                    removeSetButton(exerciseIndex: index, setIndex: setIndex)
                    
                    Text("Set \(setIndex + 1)")
                        .frame(height: 40)
                }
                
                VStack(spacing: 0) {
                    if workout.exercises[index].type == .repBased {
                        Stepper(value: $workout.exercises[index].sets[setIndex].reps, in: 1...Int.max, step: 1) {
                            Text("\(workout.exercises[index].sets[setIndex].reps) rep(s)")
                                .frame(height: 40)
                        }
                    } else {
                        Stepper(value: $workout.exercises[index].sets[setIndex].duration, in: 1...Int.max, step: 1) {
                            Text("\(workout.exercises[index].sets[setIndex].duration) second(s)")
                                .frame(height: 40)
                        }
                    }
                    
                    Divider()
                        .background(Color(uiColor: .systemGray))
                    
                    adjustWeightSection(exerciseIndex: index, setIndex: setIndex)
                    
                    Divider()
                        .background(Color(uiColor: .systemGray))
                    
                    Stepper(value: $workout.exercises[index].sets[setIndex].rest, in: 0...Int.max, step: 1) {
                        Text("\(workout.exercises[index].sets[setIndex].rest) second(s)")
                            .frame(height: 40)
                    }
                }
                .padding(.horizontal, 20)
            }
            .id(index * 10 + setIndex + 1)
            
            Divider()
                .background(Color(uiColor: .systemGray))
        }
    }
    
    private func adjustWeightSection(exerciseIndex: Int, setIndex: Int) -> some View {
        
        HStack(spacing: 20) {
            VStack(alignment: .center, spacing: 15) {
                Text("Weight")
                Text(String(format: "%.1f", workout.exercises[exerciseIndex].sets[setIndex].weight))
                Text("Kg")
            }
            
            VStack(spacing: 5) {
                Stepper(value: $workout.exercises[exerciseIndex].sets[setIndex].weight, in: 0...999, step: 20) {
                    HStack(spacing: 0) {
                        Spacer()
                        Text("20 Kg")
                    }
                }
                Stepper(value: $workout.exercises[exerciseIndex].sets[setIndex].weight, in: 0...999, step: 10) {
                    HStack(spacing: 0) {
                        Spacer()
                        Text("10 Kg")
                    }
                }
                Stepper(value: $workout.exercises[exerciseIndex].sets[setIndex].weight, in: 0...999, step: 5) {
                    HStack(spacing: 0) {
                        Spacer()
                        Text("5 Kg")
                    }
                }
                Stepper(value: $workout.exercises[exerciseIndex].sets[setIndex].weight, in: 0...999, step: 2.5) {
                    HStack(spacing: 0) {
                        Spacer()
                        Text("2.5 Kg")
                    }
                }
                Stepper(value: $workout.exercises[exerciseIndex].sets[setIndex].weight, in: 0...999, step: 0.5) {
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
extension CreateWorkoutSheetView {
    
    private func addExerciseButton() -> some View {
                
        VStack(spacing: 0) {
            Divider()
                .background(Color(uiColor: .systemGray))
            
            Menu {
                NavigationLink {
                    MultiSelectPickerView(workout: $workout)
                } label: {
                    Label("Add existing Exercise", systemImage: "chevron.right")
                }
                .disabled(isAddExistingExerciseButtonDisabled())

                Button {
                    withAnimation {
                        workout.exercises.append(ExerciseModel())
                    }

                    let exerciseCount = workout.exercises.count
                    scrollToIndex = (exerciseCount - 1) * 10 + workout.exercises[exerciseCount - 1].sets.count
                } label: {
                    Text("Add new Exercise")
                }
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
    }
    
    private func removeExerciseButton(index: Int) -> some View {
        
        Button {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            
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
    
    private func addSetButton(index: Int) -> some View {
        
        Button {
            withAnimation {
                workout.exercises[index].sets.append(SetModel())
            }
            
            scrollToIndex = index * 10 + workout.exercises[index].sets.count
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
            .frame(maxWidth: .infinity, minHeight: 40, alignment: .leading)
        }
    }
    
    private func removeSetButton(exerciseIndex: Int, setIndex: Int) -> some View {
        
        Button {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            
            workout.exercises[exerciseIndex].sets.remove(at: setIndex)
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
extension CreateWorkoutSheetView {
    
    private func isAddExistingExerciseButtonDisabled() -> Bool {
        
        return workoutManager.exercises.count == 0
    }
    
    private func isDoneButtonDisabled() -> Bool {
        
        var disableDoneButton = true
        
        if editWorkout {
            disableDoneButton = workoutManager.workoutsAreEqual(workout1: workout, workout2: workoutToCompare) || isWorkoutEmpty()

        } else {
            disableDoneButton = isWorkoutEmpty()
        }
        
        return disableDoneButton
    }
    
    private func isWorkoutEmpty() -> Bool {
        
        var isEmpty = workout.title.isEmpty
        
        if workout.exercises.count > 0 {
            workout.exercises.forEach { exercise in
                if exercise.title.isEmpty {
                    isEmpty = true
                }
            }
        } else {
            isEmpty = true
        }
        
        return isEmpty
    }
}

//MARK: - Preview
struct AddWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        BaseView()
            .environmentObject(WorkoutViewModel())
            .environmentObject(DateCalendarViewModel())
            .environmentObject(ViewRouter())
    }
}

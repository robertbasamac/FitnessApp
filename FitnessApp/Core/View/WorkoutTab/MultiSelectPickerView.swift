//
//  SelectExercisesView.swift
//  FitnessApp
//
//  Created by Robert Basamac on 18.07.2022.
//

import SwiftUI

struct MultiSelectPickerView: View {
    
    @EnvironmentObject var workoutManager: WorkoutViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    @Binding var workout: WorkoutModel
    @State var selectedExercises: [ExerciseModel] = []
        
    var body: some View {
        List {
            ForEach(workoutManager.exercises) { exercise in
                listRowView(exercise: exercise)
            }
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    workout.exercises.append(contentsOf: selectedExercises)
                    dismiss()
                } label: {
                    Text("Done")
                }
                .disabled(selectedExercises.isEmpty)
            }
        }
    }
}

extension MultiSelectPickerView {
    
    private func listRowView(exercise: ExerciseModel) -> some View {
        
        HStack {
            Image(systemName: selectedExercises.contains(exercise) ? "checkmark.circle" : "circle")
                .foregroundColor(Color(uiColor: .systemBlue))
            
            Text(exercise.title)
            
        }
        .frame(alignment: .leading)
        .onTapGesture {
            withAnimation(.linear) {
                if selectedExercises.contains(exercise) {
                    selectedExercises.removeAll(where: { $0 == exercise })
                } else {
                    selectedExercises.append(exercise)
                }
            }
        }
    }
}

struct SelectExercisesView_Previews: PreviewProvider {
    static var previews: some View {
        BaseView()
            .environmentObject(WorkoutViewModel())
            .environmentObject(DateCalendarViewModel())
            .environmentObject(ViewRouter())
    }
}

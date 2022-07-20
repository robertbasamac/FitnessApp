//
//  ListRowView.swift
//  FitnessApp
//
//  Created by Robert Basamac on 18.07.2022.
//

import SwiftUI

struct ListRowView: View {
    
    var exercise: Exercise
    @Binding var selectedExercises: [Exercise]
    
    var body: some View {
        HStack {
            Image(systemName: selectedExercises.contains(exercise) ? "checkmark.circle" : "circle")
                .foregroundColor(Color(uiColor: .systemBlue))
            
            Text(exercise.title)
            
        }
        .frame(alignment: .leading)
        .onTapGesture {
            withAnimation(.linear) {
                if self.selectedExercises.contains(exercise) {
                    self.selectedExercises.removeAll(where: { $0 == exercise })
                } else {
                    self.selectedExercises.append(exercise)
                }
            }
        }
    }
}

struct ListRowView_Previews: PreviewProvider {
    static var previews: some View {
        BaseView()
            .environmentObject(WorkoutManager())
            .environmentObject(DateModel())
            .environmentObject(ViewRouter())
    }
}

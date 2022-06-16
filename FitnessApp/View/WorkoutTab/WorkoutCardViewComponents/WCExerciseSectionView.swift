//
//  WCExerciseSectionView.swift
//  FitnessApp
//
//  Created by Robert Basamac on 12.06.2022.
//

import SwiftUI

struct WCExerciseSectionView: View {
    @Binding var workout: Workout
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ForEach(workout.exercises.indices, id: \.self) { exerciseIndex in
            VStack(alignment: .leading) {
                HStack(spacing: 20) {
                    Text("\(exerciseIndex + 1)")
                        .font(.headline)
                        .foregroundColor(colorScheme == .light ? Color.white: Color.black)
                        .padding(.horizontal)
                        .padding(.vertical, 2)
                        .background {
                            Circle()
                                .foregroundColor(colorScheme == .light ? Color.black: Color.white)
                        }
                    
                    Text(workout.exercises[exerciseIndex].title)
                        .font(.title3)
                }
                .padding(.horizontal)
                
                VStack {
                    WCSetSectionView(exercise: $workout.exercises[exerciseIndex])
                }
            }
            .padding(.all, 8)
            .background {
//                Color(uiColor: .secondarySystemFill)
//                    .cornerRadius(10)
//                    .shadow(color: Color(uiColor: .white).opacity(0.3),
//                            radius: 10,
//                            x: 0, y: 0)
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(uiColor: .secondarySystemFill))
            }
        }
    }
}

struct WCExerciseSectionView_Previews: PreviewProvider {
    static var previews: some View {
        BaseView()
            .environmentObject(WorkoutManager())
            .environmentObject(DateModel())
            .environmentObject(ViewRouter())
    }
}

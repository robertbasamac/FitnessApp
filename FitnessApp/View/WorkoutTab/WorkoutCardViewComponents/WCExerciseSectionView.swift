//
//  WCExerciseSectionView.swift
//  FitnessApp
//
//  Created by Robert Basamac on 12.06.2022.
//

import SwiftUI

struct WCExerciseSectionView: View {
    @Binding var workout: Workout
    
    var body: some View {
        ForEach($workout.exercises) { exercise in
            VStack(alignment: .center, spacing: 8) {
                Text(exercise.title.wrappedValue)
                    .font(.title3)
                
                VStack(spacing: 8) {
                    WCSetSectionView(exercise: exercise)
                }
            }
            .padding(.all, 8)
            .background {
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

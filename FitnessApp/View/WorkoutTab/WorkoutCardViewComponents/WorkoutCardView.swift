//
//  WorkoutCardView.swift
//  FitnessApp
//
//  Created by Robert Basamac on 23.05.2022.
//

import SwiftUI

struct WorkoutCardView: View {
    @Binding var workout: Workout
    @State var expandWorkout: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            WCTitleSectionView(workout: $workout)
            
            if expandWorkout {
                WCExerciseSectionView(workout: $workout)
            }
        }
        .padding(.all, 8)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(uiColor: .systemFill))
        }
        .padding(.all, 8)
        .onTapGesture {
            withAnimation {
                expandWorkout.toggle()
            }
        }
    }
}

struct WorkoutCardView_Previews: PreviewProvider {
    static var previews: some View {
        BaseView()
            .environmentObject(WorkoutManager())
            .environmentObject(DateModel())
            .environmentObject(ViewRouter())
    }
}

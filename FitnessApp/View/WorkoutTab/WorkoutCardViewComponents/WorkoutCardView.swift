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
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        LazyVStack(alignment: .leading, pinnedViews: .sectionHeaders) {
            Section {
                if expandWorkout {
                    WCExerciseSectionView(workout: $workout)
                }
            } header: {
                WCTitleSectionView(workout: $workout, expandWorkout: expandWorkout)
            }
        }
        .padding(.horizontal, 8)
        .padding(.bottom, 8)
        .padding(.top, 6)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(uiColor: .systemFill))
        }
//        .padding(.horizontal, 8)
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

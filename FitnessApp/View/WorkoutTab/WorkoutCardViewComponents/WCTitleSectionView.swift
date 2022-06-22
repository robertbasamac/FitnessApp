//
//  WorkoutCardTitleView.swift
//  FitnessApp
//
//  Created by Robert Basamac on 12.06.2022.
//

import SwiftUI

struct WCTitleSectionView: View {
    @Binding var workout: Workout
    var expandWorkout: Bool
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(workout.title)
                    .font(.title)
                    .fontWeight(.semibold)
                    .foregroundColor(expandWorkout ?
                                     (colorScheme == .light ? Color.white : Color.black)
                                     : Color(uiColor: .label))
                Spacer()
            }
            
            if workout.description.count > 0 {
                Text(workout.description)
                    .font(.caption)
                    .foregroundColor(expandWorkout ?
                                     (colorScheme == .light ? Color.white : Color.black)
                                     : Color(uiColor: .label))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 8)
        .padding(.bottom, 4)
        .background {
            if expandWorkout {
                Color(uiColor: colorScheme == .light ? .black : .white)
            }
        }
        .cornerRadius(10)
        .shadow(color: colorScheme == .light ?
                    Color.black.opacity(expandWorkout ? 0.6 : 0) :
                    Color.white.opacity(expandWorkout ? 0.6 : 0),
                radius: 10,
                x: 0, y: 0)
        .padding(.top, 2)
    }
}

struct WorkoutCardTitleView_Previews: PreviewProvider {
    static var previews: some View {
        BaseView()
            .environmentObject(WorkoutManager())
            .environmentObject(DateModel())
            .environmentObject(ViewRouter())
    }
}

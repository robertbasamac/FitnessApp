//
//  WorkoutCardTitleView.swift
//  FitnessApp
//
//  Created by Robert Basamac on 12.06.2022.
//

import SwiftUI

struct WCTitleSectionView: View {
    @Binding var workout: Workout
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(workout.title)
                    .font(.title)
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            
            if workout.description.count > 0 {
                Text(workout.description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
            }
        }
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

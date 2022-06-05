//
//  WorkoutCardView.swift
//  FitnessApp
//
//  Created by Robert Basamac on 23.05.2022.
//

import SwiftUI

struct WorkoutCardView: View {
    var workout: Workout
    
    var body: some View {
        VStack {
            Text(workout.title)
            Divider()
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

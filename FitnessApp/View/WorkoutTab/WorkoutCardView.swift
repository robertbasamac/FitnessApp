//
//  WorkoutCardView.swift
//  FitnessApp
//
//  Created by Robert Basamac on 23.05.2022.
//

import SwiftUI

struct WorkoutCardView: View {
    @State var workout: Workout
    
    var body: some View {
        Text(workout.title)
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

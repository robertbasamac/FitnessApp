//
//  WorkoutTabView.swift
//  FitnessApp
//
//  Created by Robert Basamac on 01.05.2022.
//

import SwiftUI

struct WorkoutTabView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @EnvironmentObject var dateModel: DateModel
    
    var body: some View {
        Text("Workouts")
//        ScrollView(.vertical, showsIndicators: false) {
//            VStack(alignment: .center){
//                Text("Workouts")
//            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//        }
//        .clipped()
    }
}

struct WorkoutTabView_Previews: PreviewProvider {
    static var previews: some View {
        BaseView()
            .environmentObject(WorkoutManager())
            .environmentObject(DateModel())
            .environmentObject(ViewRouter())
    }
}

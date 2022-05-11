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
    
    @State private var isShowingAddWorkoutSheet = true
    
    var body: some View {
        NavigationView {
            Text("Workouts")
                .navigationTitle("Workouts")
                .navigationViewStyle(StackNavigationViewStyle())
                .toolbar {
                    Button {
                        isShowingAddWorkoutSheet.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Add new Workout")
                    .sheet(isPresented: $isShowingAddWorkoutSheet) {
                        AddWorkoutView()
                    }
                }
        }
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

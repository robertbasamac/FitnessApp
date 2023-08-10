//
//  FitnessAppApp.swift
//  FitnessApp
//
//  Created by Robert Basamac on 18.04.2022.
//

import SwiftUI

@main
struct FitnessAppApp: App {
    @StateObject var workoutManager = WorkoutViewModel()
    @StateObject var dateModel = DateCalendarViewModel()
    @StateObject var viewRouter = ViewRouter()
//    @StateObject var coreData = CoreDataViewModel()

    var body: some Scene {
        WindowGroup {
            BaseView()
                .environmentObject(workoutManager)
                .environmentObject(dateModel)
                .environmentObject(viewRouter)
        }
    }
}

//
//  FitnessAppApp.swift
//  FitnessApp
//
//  Created by Robert Basamac on 18.04.2022.
//

import SwiftUI

@main
struct FitnessAppApp: App {
    @StateObject var workoutManager = WorkoutManager()
    @StateObject var dateModel = DateModel()
    @StateObject var viewRouter = ViewRouter()

    var body: some Scene {
        WindowGroup {
            BaseView()
                .environmentObject(workoutManager)
                .environmentObject(dateModel)
                .environmentObject(ViewRouter())
        }
    }
}

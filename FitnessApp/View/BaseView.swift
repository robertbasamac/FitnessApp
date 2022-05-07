//
//  TabView.swift
//  FitnessApp
//
//  Created by Robert Basamac on 18.04.2022.
//

import SwiftUI

struct BaseView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @EnvironmentObject var dateModel: DateModel
    @EnvironmentObject var viewRouter: ViewRouter
    
    @State private var isShowingAddWorkoutSheet = false
    
    var body: some View {
        TabView(selection: $viewRouter.currentTab) {
            HomeTabView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag(Page.home)

            CalendarTabView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }
                .tag(Page.calendar)

            NavigationView {
                WorkoutTabView()
                .navigationTitle("Workouts")
                .toolbar {
                    Button {
                        isShowingAddWorkoutSheet.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Add new Workout")
                    .sheet(isPresented: $isShowingAddWorkoutSheet) {
//                        AddWorkoutView()
                    }
                }
            }
            .tabItem {
                Image(systemName: "list.bullet.rectangle")
                Text("Workouts")
            }
            .tag(Page.workouts)

            ProfileTabView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
                .tag(Page.profile)
        }
//        .accentColor(.orange)
//        .edgesIgnoringSafeArea(.top)
    }
}

struct BGModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(uiColor: .systemGray6))
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        BaseView()
            .environmentObject(WorkoutManager())
            .environmentObject(DateModel())
            .environmentObject(ViewRouter())
    }
}

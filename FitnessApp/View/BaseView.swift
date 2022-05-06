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
    
    @State var showPopUpMenu = false
    
    init() {
//        UITabBar.appearance().backgroundColor = .systemGray6
//        UITabBar.appearance().isTranslucent = false
        
//        UITabBar.appearance().barStyle = .black
//        UITabBar.appearance().unselectedItemTintColor = .systemGray
//        UITabBar.appearance().barTintColor = .white

        
//        UITabBar.appearance().tintColor = .red

        
//        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        GeometryReader { geometry in
            //MARK: - Tab View
            TabView(selection: $viewRouter.currentTab) {
                HomeTabView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                    .tag(Page.home)
//                    .modifier(BGModifier())

                Text("Calendar")
                    .tabItem {
                        Image(systemName: "calendar")
                        Text("Calendar")
                    }
                    .tag(Page.calendar)
//                    .modifier(BGModifier())

                Text("Workouts")
                    .tabItem {
                        Image(systemName: "list.bullet.rectangle")
                        Text("Workouts")
                    }
                    .tag(Page.workouts)
//                    .modifier(BGModifier())

                Text("Profile")
                    .tabItem {
                        Image(systemName: "person")
                        Text("Profile")
                    }
                    .tag(Page.profile)
//                    .modifier(BGModifier())
            }
            .accentColor(.orange)
            .shadow(radius: 5)
//            .edgesIgnoringSafeArea(.top)
        }
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

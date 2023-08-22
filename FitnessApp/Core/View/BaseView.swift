//
//  TabView.swift
//  FitnessApp
//
//  Created by Robert Basamac on 18.04.2022.
//

import SwiftUI

struct BaseView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        TabView(selection: $viewRouter.currentTab) {
            HomeTabView()
                .tabItem {
                    Label(Page.home.rawValue, systemImage: Page.home.systemImageName)
                }
                .tag(Page.home)
            
            CalendarTabView()
                .tabItem {
                    Label(Page.calendar.rawValue, systemImage: Page.calendar.systemImageName)
                }
                .tag(Page.calendar)
            
            CollectionTabView()
                .tabItem {
                    Label(Page.collection.rawValue, systemImage: Page.collection.systemImageName)
                }
                .tag(Page.collection)
            
            ProfileTabView()
                .tabItem {
                    Label(Page.profile.rawValue, systemImage: Page.profile.systemImageName)
                }
                .tag(Page.profile)
        }
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        BaseView()
            .environmentObject(WorkoutViewModel())
            .environmentObject(DateCalendarViewModel())
            .environmentObject(ViewRouter())
    }
}

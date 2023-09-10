//
//  TabView.swift
//  FitnessApp
//
//  Created by Robert Basamac on 18.04.2022.
//

import SwiftUI

struct BaseView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    @State private var allTabs: [AnimatedTab] = Tab.allCases.compactMap { tab -> AnimatedTab? in
        return .init(tab: tab)
    }
     
//    init() {
//        let navigationBarAppearance = UINavigationBarAppearance()
//        navigationBarAppearance.configureWithDefaultBackground()
//        navigationBarAppearance.shadowColor = UIColor.clear
//        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
//        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
//        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
//        
//        let tabBarAppearanceTransparent = UITabBarAppearance()
//        tabBarAppearanceTransparent.configureWithTransparentBackground()
//        
//        let tabBarAppearanceOpaque = UITabBarAppearance()
//        tabBarAppearanceOpaque.configureWithDefaultBackground()
//        tabBarAppearanceOpaque.shadowColor = UIColor.clear
//        UITabBar.appearance().standardAppearance = tabBarAppearanceOpaque
//        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearanceOpaque
//        
//        let toolBarAppearance = UIToolbarAppearance()
//        toolBarAppearance.configureWithTransparentBackground()
////        toolBarAppearance.shadowColor = UIColor.clear
//        UIToolbar.appearance().standardAppearance = toolBarAppearance
//        UIToolbar.appearance().scrollEdgeAppearance = toolBarAppearance
//    }
    
    var body: some View {
        VStack {
            TabView(selection: $viewRouter.currentTab) {
                //            HomeTabView()
                //                .tabItem {
                //                    Label(Tab.home.rawValue, systemImage: Tab.home.systemImageName)
                //                }
                //                .tag(Tab.home)
                //
                //            CalendarTabView()
                //                .tabItem {
                //                    Label(Tab.calendar.rawValue, systemImage: Tab.calendar.systemImageName)
                //                }
                //                .tag(Tab.calendar)
                //
                //            CollectionTabView()
                //                .tabItem {
                //                    Label(Tab.collection.rawValue, systemImage: Tab.collection.systemImageName)
                //                }
                //                .tag(Tab.collection)
                //
                //            ProfileTabView()
                //                .tabItem {
                //                    Label(Tab.profile.rawValue, systemImage: Tab.profile.systemImageName)
                //                }
                //                .tag(Tab.profile)
                
                NavigationStack {
                    HomeTabView()
                    .navigationTitle(Tab.home.rawValue)
                }
                .setUpBar(.home)
                
                NavigationStack {
                    CalendarTabView()
                    .navigationTitle(Tab.calendar.rawValue)
                }
                .setUpBar(.calendar)
                
                NavigationStack {
                    CollectionTabView()
                    .navigationTitle(Tab.collection.rawValue)
                }
                .setUpBar(.collection)
                
                NavigationStack {
                    ProfileTabView()
                    .navigationTitle(Tab.profile.rawValue)
                }
                .setUpBar(.profile)
            }
            
            CustomTabBar()
        }
    }
    
    @ViewBuilder
    func CustomTabBar() -> some View {
        HStack(alignment: .center, spacing: 0, content: {
            ForEach($allTabs) { $animatedTab in
                let tab = animatedTab.tab
                
                VStack(spacing: 4, content: {
                    Image(systemName: tab.systemImageName)
                        .font(.title2)
                        .symbolEffect(.bounce.up.byLayer, value: animatedTab.isAnimatig)
                    
                    Text(tab.rawValue)
                        .font(.caption2)
                        .textScale(.secondary)
                })
                .frame(maxWidth: .infinity)
                .foregroundStyle(viewRouter.currentTab == tab ? Color.primary : Color.gray.opacity(0.8))
                .padding(.top, 15)
                .padding(.bottom, 10)
                .contentShape(.rect)
                .onTapGesture {
                    withAnimation(.bouncy, completionCriteria: .logicallyComplete) {
                        viewRouter.currentTab = tab
                        animatedTab.isAnimatig = true
                    } completion: {
                        var transaction = Transaction()
                        transaction.disablesAnimations = true
                        
                        withTransaction(transaction) {
                            animatedTab.isAnimatig = nil
                        }
                    }
                }
            }
        })
        .background(.bar)
    }
}

extension View {
    @ViewBuilder
    func setUpBar(_ tab: Tab) -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .tag(tab)
            .toolbar(.hidden, for: .tabBar)
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

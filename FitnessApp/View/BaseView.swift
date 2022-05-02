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
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                //MARK: - Tab View
                TabView(selection: $viewRouter.currentTab) {
                    HomeTabView()
                        .tag(Page.home)
                        .modifier(BGModifier())

                    Text("Calendar")
                        .tag(Page.calendar)
                        .modifier(BGModifier())

                    Text("Workouts")
                        .tag(Page.workouts)
                        .modifier(BGModifier())

                    Text("Profile")
                        .tag(Page.profile)
                        .modifier(BGModifier())
                }
                .edgesIgnoringSafeArea(.top)
                
                //MARK: - Custom Tab Bar
                ZStack {
                    if showPopUpMenu {
                        PopUpMenu(width: geometry.size.width/8, height: geometry.size.height/14)
                            .offset(y: -geometry.size.height/9)
                    }
                    HStack(spacing: 0) {
                        TabBarIcon (assignedPage: .home, width: geometry.size.width/15, height: geometry.size.height/32)
                        
                        TabBarIcon (assignedPage: .calendar, width: geometry.size.width/15, height: geometry.size.height/32)
                        
                        TabBarMenuIcon(showPopUpMenu: $showPopUpMenu, width: geometry.size.width/8, height: geometry.size.height/14/2)
                        
                        TabBarIcon (assignedPage: .workouts, width: geometry.size.width/15, height: geometry.size.height/32)
                        
                        TabBarIcon (assignedPage: .profile, width: geometry.size.width/15, height: geometry.size.height/32)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(width: geometry.size.width, height: geometry.size.height/14)
                    .background {
                        Color(UIColor.systemGray6)
                            .edgesIgnoringSafeArea(.bottom)
                    }
                    .shadow(radius: 2)
                }
            }
        }
    }
}

struct TabBarIcon: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
    let assignedPage: Page
    
    let width, height: CGFloat
    
    var body: some View {
        VStack(spacing: 2) {
            Image(systemName: assignedPage.systemImageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width, height: height)
            Text(assignedPage.title)
                .font(.footnote)
        }
        .padding(.top, 5)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundColor(
            viewRouter.currentTab == assignedPage ? Color(UIColor.systemPurple) : Color(UIColor.systemGray)
        )
        .onTapGesture {
            viewRouter.currentTab = assignedPage
        }
    }
}

struct TabBarMenuIcon: View {
    @Binding var showPopUpMenu: Bool
    
    let width, height: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.white)
                .frame(width: width, height: width)
                .shadow(color: .purple, radius: 10, x: 0, y: 0)
            Image(systemName: "plus.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width-6, height: width-6)
                .foregroundColor(.purple)
                .rotationEffect(Angle(degrees: showPopUpMenu ? 45 : 0))
        }
        .offset(y: -height)
        .onTapGesture {
            withAnimation {
                showPopUpMenu.toggle()
            }
        }
    }
}

struct BGModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(UIColor.systemGray5))
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

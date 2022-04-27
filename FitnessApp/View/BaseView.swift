//
//  TabView.swift
//  FitnessApp
//
//  Created by Robert Basamac on 18.04.2022.
//

import SwiftUI

struct BaseView: View {
    @State var currentTab: String = "home"
    
    // Hiding native bar
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 0) {
            
            //MARK: - Tab View
            TabView(selection: $currentTab) {
                HomeView()
                    .tag("home")
                    .modifier(BGModifier())
                
                Text("Workouts")
                    .tag("workouts")
                    .modifier(BGModifier())
                
                Text("Calendar")
                    .tag("calendar")
                    .modifier(BGModifier())
                
                Text("Profile")
                    .tag("profile")
                    .modifier(BGModifier())
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .edgesIgnoringSafeArea(.top)
            
            //MARK: - Custom Tab Bar
            HStack(alignment: .lastTextBaseline) {
                
                TabButton(tab: "home", image: "house")
                
                TabButton(tab: "workouts", image: "list.bullet")

                // Center Add Button
                Button {
                    
                } label: {
                     Image(systemName: "plus")
                        .font(.system(size: 25, weight: .semibold))
                        .foregroundColor(.white)
                        .padding()
                        .background {
                            Circle()
                                .fill(Color.mint)
                        }
                        .shadow(color: Color.mint.opacity(0.8), radius: 12, x: 0, y: 8)
                    
                }
                // Moving Button little up
                .offset(y: -30)
                .padding(.horizontal, 5)

                TabButton(tab: "calendar" ,image: "calendar")
                
                TabButton(tab: "profile", image: "person")
            }
//            .padding(.top, -8)
            .frame(maxWidth: .infinity)
            .background {
//                Color(UIColor.systemGray6)
                Color.mint.opacity(0.35)
                    .ignoresSafeArea()
            }
            // add top line
            .background(
                GeometryReader { parentGeometry in // 2
                    Rectangle()
                        .fill(Color(UIColor.systemGray2))
                        .frame(width: parentGeometry.size.width, height: 0.5) // 3
                        .position(x: parentGeometry.size.width / 2, y: 0) // 4
                }
            )
        }
    }
    
    //MARK: - Tab Button
    @ViewBuilder
    func TabButton(tab: String, image: String) -> some View {
        
        Button {
            withAnimation {
                currentTab = tab
            }
            
        } label: {
            Image(systemName: image)
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
                .frame(maxWidth: .infinity)
                .foregroundColor(
                    currentTab == tab ? Color(UIColor.systemMint) : Color(UIColor.systemGray)
                )
        }
    }
}

struct BGModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Color.mint.opacity(0.15))
//                Color(UIColor.systemMint)).opacity(0.15)
//                Color(uiColor: .systemBackground))
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

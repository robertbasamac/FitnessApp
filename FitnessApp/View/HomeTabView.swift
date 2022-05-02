//
//  HomeView.swift
//  FitnessApp
//
//  Created by Robert Basamac on 18.04.2022.
//

import SwiftUI

struct HomeTabView: View {
    @Namespace var animation
    
    @EnvironmentObject var workoutManager: WorkoutManager
    @EnvironmentObject var dateModel: DateModel
    
    init() {
            UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 10, pinnedViews: [.sectionHeaders]) {
                    Section {
                        //MARK: - Week View
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 4) {
                                ForEach(dateModel.currentWeek, id: \.self) { day in
                                    VStack() {
                                        // EEE will return day number
                                        Text(dateModel.extractDate(date: day, format: "dd"))
                                            .font(.system(size: 15))
                                            .fontWeight(.semibold)
                                        
                                        // EEE will return day as MON, TUE ...
                                        Text(dateModel.extractDate(date: day, format: "EE"))
                                            .font(.system(size: 14))
                                        Circle()
                                            .fill(dateModel.isToday(date: day) ? .white : .black)
                                            .frame(width: 8, height: 8)
                                            .opacity(workoutManager.hasWorkouts(for: dateModel.extractDate(date: day, format: "dd/ee/yyy")) ? 1 : 0)
                                    }
                                    .foregroundStyle(dateModel.isToday(date: day) ? .primary : .tertiary)
                                    .foregroundColor(dateModel.isToday(date: day) ? .white : .black)
                                    .frame(width: (geometry.size.width - 32) / 7, height: geometry.size.width / 7 * 1.5)
                                    .background (
                                        ZStack {
                                            if dateModel.isToday(date: day) {
                                                Capsule()
                                                    .fill(.black)
                                                    .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                                            }
                                        }
                                    )
                                    .contentShape(Capsule())
                                    .onTapGesture {
                                        withAnimation {
                                            dateModel.currentDay = day
                                        }
                                    }
                                }
                            }
                            .padding(.vertical, 5)
                            .frame(maxWidth: .infinity)
                            .frame(minWidth: geometry.size.width)      // make the scroll view content full-width
                            .background(
                                GeometryReader { parentGeometry in
                                    Rectangle()
                                        .fill(Color(UIColor.systemGray2))
                                        .frame(width: parentGeometry.size.width, height: 0.5)
                                        .position(x: parentGeometry.size.width / 2, y: parentGeometry.size.height)
                                }
                            )
                        }
                        WorkoutsView()
                    } header: {
                        HeaderView()
                    }
                }
            }
            .frame(maxHeight: .infinity)
        }
        .clipped()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        BaseView()
            .environmentObject(WorkoutManager())
            .environmentObject(DateModel())
            .environmentObject(ViewRouter())
    }
}

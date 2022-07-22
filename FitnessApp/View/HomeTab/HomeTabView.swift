//
//  HomeView.swift
//  FitnessApp
//
//  Created by Robert Basamac on 18.04.2022.
//

import SwiftUI

struct HomeTabView: View {   
    @EnvironmentObject var workoutManager: WorkoutManager
    @EnvironmentObject var dateModel: DateModel
        
    @Environment(\.colorScheme) var colorScheme
    
    @State private var showPreviousWeek: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                    Section {
                        updateWeekSection
                        
                        ZStack {
                            ForEach(dateModel.displayedWeeks, id: \.self) { week in
                                if week == dateModel.currentWeek {
                                    WeekView(week: week)
                                        .transition(.asymmetric(
                                            insertion: .move(edge: showPreviousWeek ? .leading : .trailing),
                                            removal: .move(edge: showPreviousWeek ? .trailing : .leading)))
                                }
                                
                            }
                        }
                        
                        todayWorkoutsSection
                    } header: {
                        headerSection
                    }
                }
            }
            .frame(maxHeight: .infinity)
        }
        .clipped()
    }
}

//MARK: - Content Views

extension HomeTabView {
    
    private var headerSection: some View {
        
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 15) {
                Text(Date().formatted(date: .abbreviated, time: .omitted))
                    .foregroundColor(.gray)
                
                Text(dateModel.extractDate(date: Date(), format: "EEEE"))
                    .font(.largeTitle.bold())
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Button {
                
            } label: {
                Image("Profile")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 45, height: 45)
                    .clipShape(Circle())
            }
        }
        .padding()
        .background {
            Color(uiColor: .systemBackground)
        }
    }
    
    private var updateWeekSection: some View {
        
        HStack {
            Button {
                showPreviousWeek = true
                dateModel.showPreviousWeek()
            } label: {
                Image(systemName: "chevron.left")
                    .padding(.horizontal)
            }
            
            Button {
                dateModel.showCurrentWeek()
            } label: {
                Text("Today")
                    .padding(.horizontal)
            }
            
            Button {
                showPreviousWeek = false
                dateModel.showNextWeek()
            } label: {
                Image(systemName: "chevron.right")
                    .padding(.horizontal)
            }
        }
        .foregroundColor(colorScheme == .light ? Color.black : Color.white)
        .frame(maxWidth: .infinity)
    }
    
    private var todayWorkoutsSection: some View {
        
        LazyVStack {
            if let workouts = workoutManager.getWorkouts(for: dateModel.extractDate(date: dateModel.selectedDay, format: "dd/MM/yyy")) {
                ForEach(workouts) { workout in
                    Text("\(workout.title)")
                        .font(.system(size: 16))
                }
            } else {
                Text("No workouts assigned.")
                    .font(.system(size: 16))
                    .foregroundColor(.red)
            }
        }
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

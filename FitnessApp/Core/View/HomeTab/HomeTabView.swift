//
//  Home.swift
//  FitnessApp
//
//  Created by Robert Basamac on 10.08.2023.
//

import SwiftUI

struct HomeTabView: View {
    
    @EnvironmentObject var dateModel: DateCalendarViewModel
    
    @Namespace private var animation
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView()
        }
        .vSpacing(.top)
    }
}

extension HomeTabView {
    
    // MARK: - HeaderView
    
    @ViewBuilder
    func HeaderView() -> some View {
        VStack(spacing: 0) {
            // Current Date Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(Date.init().format("eeee"))
                        .foregroundStyle(.red)
                        .font(.title.weight(.semibold))
                    
                    Text(Date.init().formatted(date: .long, time: .omitted))
                        .font(.callout.weight(.medium))
                }
                .onTapGesture(perform: {
                        dateModel.generateWeeks()
                })
                
                Spacer()
                
                // Profile Picture
                Button {
                    
                } label: {
                    Image("Profile")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 45, height: 45)
                        .clipShape(Circle())
                }
            }
            .hSpacing(.leading)
            .padding(.horizontal, 15)
            .padding(.vertical, 8)
            
            // Week Days initials
            HStack(alignment: .center, spacing: 0) {
                ForEach(dateModel.weekDaysInitials) { day in
                    Text(day.weekDay)
                        .font(.callout.weight(.regular))
                        .textScale(.secondary)
                }
                .hSpacing(.center)
            }
            
            // Week Slider
            TabView(selection: $dateModel.currentWeekIndex, content:  {
                ForEach(dateModel.weekSlider.indices, id: \.self) { index in
                    WeekView(dateModel.weekSlider[index])
                        .tag(index)
                }
            })
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 45)
            
            // Selected Date fotter
            Text(dateModel.weekSelectedDate.formatted(date: .complete, time: .omitted))
                .hSpacing(.center)
                .overlay(alignment: .leading) {
                    Text("W\(dateModel.weekSelectedDate.format("ww"))")
                        .foregroundStyle(Color(uiColor: .secondaryLabel))
                }
                .padding(.horizontal, 8)
        }
        .onChange(of: dateModel.currentWeekIndex, initial: false) { oldValue, newValue in
            // Creating new weeks when index reaches first/last Page
            if newValue == 0 || newValue == (dateModel.weekSlider.count - 1) {
                dateModel.createWeek = true
            }
        }
    }
    
    // MARK: - WeekView
    
    @ViewBuilder
    func WeekView(_ week: [Date.WeekDay]) -> some View {
        HStack(spacing: 0) {
            ForEach(week) { day in
                DayCardView(day)
                    .onTapGesture {
                        withAnimation {
                            dateModel.weekSelectedDate = day.date
                        }
                    }
            }
        }
        .background {
            GeometryReader {
                let minX = $0.frame(in: .global).minX
                
                Color.clear
                    .preference(key: OffsetKey.self, value: minX)
                    .onPreferenceChange(OffsetKey.self) { value in
                        // When the offset changes and if the createWeek is toggled then simply generate next set of weeks
                        if value.rounded() == 0 && dateModel.createWeek {
                            dateModel.updateWeeks()
                        }
                    }
            }
        }
    }
    
    // MARK: - DayCardView
    
    @ViewBuilder
    func DayCardView(_ day: Date.WeekDay) -> some View {
        Text(day.date.format("d"))
            .font(.title3)
            .foregroundStyle(getForegroundColor(for: day.date))
            .frame(width: 45, height: 45)
            .hSpacing(.center)
            .background(content: {
                if day.date.isSameDayAs(dateModel.weekSelectedDate) {
                    Circle()
                        .fill((day.date.isToday ? .red : Color(uiColor: .label)))
                        .matchedGeometryEffect(id: "SELECTEDDATE", in: animation)
                        .frame(width: 35, height: 35)

                }
            })
            .contentShape(.rect)
    }
    
    // MARK: - Helper methods
    
    func getForegroundColor(for date: Date) -> Color {
        return (date.isToday) ?
            (date.isSameDayAs(dateModel.weekSelectedDate) ? .white : .red) :
            (date.isSameDayAs(dateModel.weekSelectedDate) ? Color(uiColor: .systemBackground) : Color(uiColor: .label))
    }
}

#Preview {
    HomeTabView()
        .environmentObject(DateCalendarViewModel())
}

//
//  Home.swift
//  FitnessApp
//
//  Created by Robert Basamac on 10.08.2023.
//

import SwiftUI

struct HomeTabView: View {
    
    @EnvironmentObject var dateModel: DateCalendarViewModel
    
    /// Animation Namespace
    @Namespace private var animation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HeaderView()
        }
        .vSpacing(.top)
    }
}

extension HomeTabView {
    @ViewBuilder
    func HeaderView() -> some View {
        VStack(alignment: .center, spacing: 0) {
            /// Current Date Header
            HStack(alignment: .center) {
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
                
                /// Profile Picture
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
            
            /// Week Days initials
            HStack(alignment: .center, spacing: 0) {
                ForEach(dateModel.weekSlider[dateModel.currentWeekIndex]) { day in
                    Text(day.date.format("EEEEE"))
                        .font(.callout.weight(.regular))
                        .textScale(.secondary)
                }
                .hSpacing(.center)
            }
            
            /// Week Slider
            TabView(selection: $dateModel.currentWeekIndex,
                    content:  {
                ForEach(dateModel.weekSlider.indices, id: \.self) { index in
                    WeekView(dateModel.weekSlider[index])
                        .tag(index)
                }
            })
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 45)
            
            /// Selected Date fotter
            Text(dateModel.currentDate.formatted(date: .complete, time: .omitted))
                .hSpacing(.center)
                .overlay(alignment: .leading) {
                    Text("W\(dateModel.currentDate.format("ww"))")
                        .foregroundStyle(Color(uiColor: .secondaryLabel))
                }
                .padding(.horizontal, 8)
        }
        .onChange(of: dateModel.currentWeekIndex, initial: false) { oldValue, newValue in
            /// Creating new weeks when index reaches first/last Page
            if newValue == 0 || newValue == (dateModel.weekSlider.count - 1) {
                dateModel.createWeek = true
            }
        }
    }
    
    /// Week View
    @ViewBuilder
    func WeekView(_ week: [Date.WeekDay]) -> some View {
        HStack(spacing: 0) {
            ForEach(week) { day in
                Text(day.date.format("dd"))
                    .font(.title3)
                    .foregroundStyle(dateModel.isSameDay(day.date, Date.init()) ?
                                     (dateModel.isSameDay(day.date, dateModel.currentDate) ? .white : .red) :
                                        ((dateModel.isSameDay(day.date, dateModel.currentDate) ? Color(uiColor: .systemBackground) : Color(uiColor: .label)))
                    )
                    .frame(width: 35, height: 35)
                    .background(content: {
                        if dateModel.isSameDay(day.date, dateModel.currentDate) {
                            Circle()
                                .fill((dateModel.isSameDay(day.date, Date.init()) ? .red : Color(uiColor: .label)))
                                .matchedGeometryEffect(id: "TABINDICATOR", in: animation)
                        }
                    })
                    .hSpacing(.center)
                    .padding(.vertical, 5)
                    .contentShape(.rect)
                    .onTapGesture {
                        /// Updating Current Date
                        withAnimation(.snappy) {
                            dateModel.currentDate = day.date
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
                        /// When the offset reaches 15 and if the createWeek is toggled then simply generate next set of weeks
                        if value.rounded() == 0 && dateModel.createWeek {
                            dateModel.updateWeeks()
                        }
                    }
            }
        }
    }
}

#Preview {
    HomeTabView()
        .environmentObject(DateCalendarViewModel())
}

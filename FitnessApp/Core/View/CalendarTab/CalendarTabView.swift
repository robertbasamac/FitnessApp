//
//  CalendarTabView.swift
//  FitnessApp
//
//  Created by Robert Basamac on 01.05.2022.
//

import SwiftUI

struct CalendarTabView: View {

    @EnvironmentObject var dateModel: DateCalendarViewModel
    
    @State private var tabHeight: CGFloat = 100
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView()
            
            Divider()
            
            ScrollView(.vertical) {
                VStack {
                    Text("Scroll View Test")
                }
                .padding()
                .vSpacing(.top)
                .hSpacing(.center)
            }
        }
        .clipped()
    }
}

extension CalendarTabView {
    
    // MARK: - HeaderView
    
    @ViewBuilder
    func HeaderView() -> some View {
        VStack(spacing: 0) {
            // Current Month Header
            HStack(spacing: 10) {
                Text((dateModel.monthSlider[dateModel.currentMonthIndex][15].date).format("MMMM"))
                    .foregroundStyle(.red)
                Text((dateModel.monthSlider[dateModel.currentMonthIndex][15].date).format("yyyy"))
            }
            .font(.title.weight(.semibold))
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
            
            // Month Slider
            TabView(selection: $dateModel.currentMonthIndex, content:  {
                ForEach(dateModel.monthSlider.indices, id: \.self) { index in
                    MonthView(dateModel.monthSlider[index])
                        .tag(index)
                        .background {
                            GeometryReader { geometry in
                                Color.clear
                                    .preference(key: TabViewHeightPreference.self, value: geometry.frame(in: .local).height)
                            }
                        }
                }
            })
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(minHeight: 100)
            .frame(height: tabHeight)
            .onPreferenceChange(TabViewHeightPreference.self) { height in
                if height != 0 {
                    self.tabHeight = height
                }
            }
        }
        .onChange(of: dateModel.currentMonthIndex, initial: false) { oldValue, newValue in
            // Creating new months when index reaches first/last Page
            if newValue == 0 || newValue == (dateModel.monthSlider.count - 1) {
                dateModel.createMonth = true
            }
        }
    }
    
    // MARK: - MonthView
    
    @ViewBuilder
    func MonthView(_ month: [Date.MonthDay]) -> some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 7), spacing: 0, content: {
            ForEach(month) { date in
                DayCardView(day: date)
                    .onTapGesture {
                        withAnimation {
                            dateModel.monthSelectedDate = date.date
                        }
                        print(date.date.description)
                    }
                    .allowsHitTesting(date.day != -1) // does not allow to press on dates not being part of the displayed month (grayed ones)
            }
        })
        .background {
            GeometryReader {
                let minX = $0.frame(in: .global).minX
                
                Color.clear
                    .preference(key: OffsetKey.self, value: minX)
                    .onPreferenceChange(OffsetKey.self) { value in
                        // When the offset changes and if the createMonth is toggled then simply generate next set of months
                        if value.rounded() == 0 && dateModel.createMonth {
                            dateModel.updateMonths()
                        }
                    }
            }
        }
    }
    
    // MARK: - DayCardView
    
    @ViewBuilder
    func DayCardView(day: Date.MonthDay) -> some View {
        Text("\(day.date.format("d"))")
            .font(.title3)
            .foregroundStyle(day.day == -1 ? .secondary : .primary)
            .foregroundStyle(getForegroundColor(for: day.date))
            .frame(width: 45, height: 45)
            .hSpacing(.center)
            .background(content: {
                if day.date.isSameDayAs(dateModel.monthSelectedDate) {
                    Circle()
                        .fill((day.date.isToday ? .red : Color(uiColor: .label)))
                        .frame(width: 35, height: 35, alignment: .center)
                }
            })
            .contentShape(.rect)
    }
    
    // MARK: - Helper methods
    
    func getForegroundColor(for date: Date) -> Color {
        return (date.isToday) ?
            (date.isSameDayAs(dateModel.monthSelectedDate) ? .white : .red) :
            (date.isSameDayAs(dateModel.monthSelectedDate) ? Color(uiColor: .systemBackground) : Color(uiColor: .label))
    }
}

// MARK: - Preview

struct CalendarTabView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarTabView()
            .environmentObject(WorkoutViewModel())
            .environmentObject(DateCalendarViewModel())
            .environmentObject(ViewRouter())
    }
}

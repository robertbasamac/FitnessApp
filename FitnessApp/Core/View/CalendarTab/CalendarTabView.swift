//
//  CalendarTabView.swift
//  FitnessApp
//
//  Created by Robert Basamac on 01.05.2022.
//

import SwiftUI

struct CalendarTabView: View {
    
    @EnvironmentObject var dateModel: DateCalendarViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HeaderView()
            
            CalendarGrid()
        }
        .vSpacing(.top)
    }
}

extension CalendarTabView {
    @ViewBuilder
    func HeaderView() -> some View {
        VStack {
            HStack {
                Spacer()
                
                Button(action: {
                    previousMonth()
                }, label: {
                    Image(systemName: "arrow.left")
                        .imageScale(.large)
                        .font(.title)
                })
                
                Text(CalendarHelper().monthYearString(dateModel.date))
                    .font(.title.bold())
                    .animation(.none)
                    .hSpacing(.center)
                
                Button(action: {
                    nextMonth()
                }, label: {
                    Image(systemName: "arrow.right")
                        .imageScale(.large)
                        .font(.title)
                })
                
                Spacer()
            }
            .padding()
            
            HStack(alignment: .center, spacing: 0) {
                ForEach(dateModel.weekSlider[dateModel.currentWeekIndex]) { day in
                    Text(day.date.format("EEEEE"))
                        .font(.callout.weight(.regular))
                        .textScale(.secondary)
                }
                .hSpacing(.center)
            }
        }
    }
    
    @ViewBuilder
    func CalendarGrid() -> some View {
        VStack {
            let daysInMonth = CalendarHelper().daysInMonth(dateModel.date)
            let firstDayOfMonth = CalendarHelper().firstOfMonth(dateModel.date)
            let startingSpaces = CalendarHelper().weekDay(firstDayOfMonth)
            let prevMonth = CalendarHelper().minusMonth(dateModel.date)
            let daysInPrevMonth = CalendarHelper().daysInMonth(prevMonth)
            
            ForEach(0..<6) { row in
                HStack {
                    ForEach(1..<8) { column in
                        let count = column + (row * 7)
                        
                        CalendarCell(count: count, startingSpaces: startingSpaces, daysInMonth: daysInMonth, daysInPrevMonth: daysInPrevMonth)
                            .environmentObject(dateModel)
                    }
                }
            }
        }
        .vSpacing(.top)
    }
    
    func previousMonth() {
        dateModel.date = CalendarHelper().minusMonth(dateModel.date)
    }
    
    func nextMonth() {
        dateModel.date = CalendarHelper().plusMonth(dateModel.date)
    }
}

struct CalendarTabView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarTabView()
            .environmentObject(WorkoutViewModel())
            .environmentObject(DateCalendarViewModel())
            .environmentObject(ViewRouter())
    }
}

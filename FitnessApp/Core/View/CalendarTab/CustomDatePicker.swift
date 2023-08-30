 //
//  CustomDatePicker.swift
//  FitnessApp
//
//  Created by Robert Basamac on 29.08.2023.
//

import SwiftUI

struct CustomDatePicker: View {
    @EnvironmentObject var dateModel: DateCalendarViewModel
    
    @State var currentMonth: Int = 0
    
    var body: some View {
        VStack(spacing: 2) {
            
            HStack(spacing: 20) {
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(extractYearAndMonth()[0])
                        .font(.caption)
                        .fontWeight(.semibold)
                    
                    Text(extractYearAndMonth()[1])
                        .font(.title.bold())
                }
                
                Spacer(minLength: 0)
                
                Button(action: {
                    dateModel.currentMonthIndex = 0
//                    currentMonth -= 1
                }, label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                })
                
                Button(action: {
                    dateModel.currentMonthIndex = 2
//                    currentMonth += 1
                }, label: {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                })
            }
            .padding(.horizontal)
            
            // Day View
            HStack(alignment: .center, spacing: 0) {
                ForEach(/*extractDate()*/dateModel.weekSlider[dateModel.currentWeekIndex]) { day in
                    Text(day.date.format("EEEEE"))
                        .font(.callout.weight(.regular))
                        .textScale(.secondary)
                }
                .hSpacing(.center)
            }
            
            // Dates
            // Lazy Grid
            let columns = Array(repeating: GridItem(.flexible()), count: 7)
            
            LazyVGrid(columns: columns, content: {
                ForEach(dateModel.monthSlider[dateModel.currentMonthIndex]) { date in
                    CardView(date: date)
                        .onTapGesture {
                            print(date.date.description)
                        }
                }
            })
        }
        .onChange(of: currentMonth) { oldValue, newValue in
            dateModel.currentDate  = getCurrentMonth()
        }
    }
    
    @ViewBuilder
    func CardView(date: Date.MonthDay) -> some View {
        VStack {
//            if date.day != -1 {
                Text("\(date.date.format("d"))")
                    .font(.title3)
                    .foregroundStyle(date.day == -1 ? .secondary : .primary)
//            }
        }
        .padding(.vertical, 8)
        .frame(height: 60, alignment: .top)
    }
    
    func extractYearAndMonth() -> [String] {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "YYYY MMMM"
        
        let date = formatter.string(from: dateModel.currentDate)
        
        return date.components(separatedBy: " ")
    }
    
    func getCurrentMonth() -> Date {
        let calendar = Calendar.autoupdatingCurrent
        
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date.init()) else {
            return Date.init()
        }
        
        return currentMonth
    }
    
    func extractDate() -> [Date.MonthDay] {
        let calendar = Calendar.autoupdatingCurrent
        
        // Getting current month Date
//        let currentMonth = getCurrentMonth()
        
        var days =  dateModel.fetchMonth().compactMap { date -> Date.MonthDay in
            let day = calendar.component(.day, from: date.date)
            
            return Date.MonthDay(day: day, date: date.date)
        }
        
        // adding offset days to get exact week day
        let firstWeekDay = calendar.component(.weekday, from: days.first?.date ?? Date.init())

        let startOfDate = calendar.startOfDay(for: dateModel.currentDate)
        
        let weekForDate = calendar.dateInterval(of: .weekOfMonth, for: startOfDate)
        
        guard let startOfWeek = weekForDate?.start else {
            return []
        }
        
        let dayStartOfWeek = calendar.component(.weekday, from: startOfWeek)
        
        let offset = ((firstWeekDay - dayStartOfWeek) + 7) % 7

        for _ in 0..<offset {
            days.insert(Date.MonthDay(day: -1, date: Date.init()), at: 0)
        }
        
        return days
    }
}

#Preview {
    CustomDatePicker()
        .environmentObject(DateCalendarViewModel())
}

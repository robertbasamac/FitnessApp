//
//  DateModel.swift
//  FitnessApp
//
//  Created by Robert Basamac on 18.04.2022.
//

import Foundation
import SwiftUI

class DateCalendarViewModel: ObservableObject {
    
    // MARK: - Properties
    
    // Home View Week Slider properties
    @Published var selectedDate: Date = .init()
    @Published var weekSlider: [[Date.WeekDay]] = []
    @Published var currentWeekIndex: Int = 1
    @Published var createWeek: Bool = false
    
    // Calendar View Month Slider properties
    @Published var currentDate: Date = .init()
    @Published var monthSlider: [[Date.MonthDay]] = []
    @Published var currentMonthIndex: Int = 1
    @Published var createMonth: Bool = false

    private let calendar = Calendar.autoupdatingCurrent
    
    init() {
        generateWeeks()
        generateMonths()
    }
    
    //MARK: - Week Slider methods
    
    /// Generates and resets the weeks displayed in the WeekSlider based on the current date (previous, current, next).
    func generateWeeks() {
        weekSlider.removeAll()
        
        let currentWeek = fetchWeek()
        
        if let firstDate = currentWeek.first?.date {
            weekSlider.append(createPreviousWeek(for: firstDate))
        }
        
        weekSlider.append(currentWeek)
        
        if let lastDate = currentWeek.last?.date {
            weekSlider.append(createNextWeek(for: lastDate))
        }
        
        selectedDate = Date.init()
    }
    
    /// Updates the weeks displayed in the WeekSlider by creating new next/previous weeks and removing the older ones in order to always store and display the previous, current and next weeks.
    func updateWeeks() {
        if weekSlider.indices.contains(currentWeekIndex) {
            if let firstDate = weekSlider[currentWeekIndex].first?.date, currentWeekIndex == 0 {
                /// Inserting Previous Week at 0th index and removing Next Week
                weekSlider.insert(createPreviousWeek(for: firstDate), at: 0)
                weekSlider.removeLast()
            }
        
            if let lastDate = weekSlider[currentWeekIndex].last?.date, currentWeekIndex == (weekSlider.count - 1) {
                /// Inserting Next Week at 0th index and removing First Week
                weekSlider.append(createNextWeek(for: lastDate))
                weekSlider.removeFirst()
            }
            
            currentWeekIndex = 1
        }
        
        createWeek = false
    }
    
    /// Fetches an entire Week for a given Date.
    func fetchWeek(for date: Date = .init()) -> [Date.WeekDay] {
        let startOfDate = calendar.startOfDay(for: date)
        
        var week: [Date.WeekDay] = []
        let weekForDate = calendar.dateInterval(of: .weekOfMonth, for: startOfDate)
        
        guard let startOfWeek = weekForDate?.start else {
            return []
        }
        
        (0..<7).forEach { index in
            if let weekDay = calendar.date(byAdding: .day, value: index, to: startOfWeek) {
                week.append(.init(date: weekDay))
            }
        }
        
        return week
    }
    
    /// Creates an entire Week that precedes a given date.
    func createPreviousWeek(for date: Date = .init()) -> [Date.WeekDay] {
        let startOfFirstDate = calendar.startOfDay(for: date)
        
        guard let previousDate = calendar.date(byAdding: .day, value: -1, to: startOfFirstDate) else {
            return []
        }
        
        return fetchWeek(for: previousDate)
    }
    
    /// Creates an entire Week that follows a given date.
    func createNextWeek(for date: Date = .init()) -> [Date.WeekDay] {
        let startOfLastDate = calendar.startOfDay(for: date)
        
        guard let nextDate = calendar.date(byAdding: .day, value: 1, to: startOfLastDate) else {
            return []
        }
        
        return fetchWeek(for: nextDate)
    }
    
    //MARK: - Month Slider methods
    
    /// Generates and resets the weeks displayed in the WeekSlider based on the current date (previous, current, next).
    func generateMonths() {
        monthSlider.removeAll()
        
        let currentMonth = fetchMonth()
        
        if let firstDateOfMonth = currentMonth.first?.date {
//            print("generateMonths:firstDateOfMonth: \(firstDateOfMonth)")
            monthSlider.append(createPreviousMonth(for: firstDateOfMonth))
        }
        
        monthSlider.append(currentMonth)
        
        if let lastDate = currentMonth.last?.date {
            monthSlider.append(createNextMonth(for: lastDate))
        }
        
        currentDate = Date.init()
    }
    
    /// Fetches an entire Month for a given Date.
    func fetchMonth(for date: Date = .init()) -> [Date.MonthDay] {
//        print("fetchMonth:date: \(date)")

        let startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
//        print("fetchMonth:startDate: \(startDate)")
        
        let range = calendar.range(of: .day, in: .month, for: startDate)!
//        print("range.count: \(range.count)")

        // get month days as MonthDay(Int, Date)
        var monthDays =  range.compactMap { day -> Date.MonthDay in
            let date = calendar.date(byAdding: .day, value: day - 1, to: startDate) ?? Date.init()
            
            let day = calendar.component(.day, from: date)
            let monthDay = Date.MonthDay(day: day, date: date)

            return monthDay
        }
        
        let firstWeekDay = calendar.component(.weekday, from: startDate)
//        print("fetchMonth:firstWeekDay: \(firstWeekDay)")

        // compute the offset (Calendar first day of week - startOfWeek) to shift the days of the month to the right in order to match the weekdays position
        // TODO - startOfWeek ca be computed once for the entire class, store it and access it when needed
        let startOfDate = calendar.startOfDay(for: date)
//        print("fetchMonth:startOfDate: \(startOfDate)")

        let weekForDate = calendar.dateInterval(of: .weekOfMonth, for: startOfDate)

        guard let startOfWeek = weekForDate?.start else {
            return monthDays
        }
        
//        print("fetchMonth:startOfWeek: \(startOfWeek)")

        let startOfWeekDay = calendar.component(.weekday, from: startOfWeek)
//        print("fetchMonth:startOfWeekDay: \(startOfWeekDay)")
        
        // compute how many dates should be added to fill the current month (before the first day of the month)
        let previousOffset = ((firstWeekDay - startOfWeekDay) + 7) % 7
        
        // insert previous month dates before the first day of the current month
        for _ in 0..<previousOffset {
            let dateToInsert = calendar.date(byAdding: .day, value: -1, to: monthDays.first?.date ?? Date.init())
            monthDays.insert(Date.MonthDay(day: -1, date: dateToInsert ?? Date.init()), at: 0)
        }
        
        // compute how many dates should be added to fill the current month (after the last day of the month)
        let weeksToDisplay = Int(ceil((Double(range.count) + Double(previousOffset)) / 7))
        
        let nextOffset = weeksToDisplay * 7 - (range.count + previousOffset)
        
        // insert next month dates after the last day of the current month
        for _ in 0..<nextOffset {
            let dateToInsert = calendar.date(byAdding: .day, value: 1, to: monthDays.last?.date ?? Date.init())
            monthDays.append(Date.MonthDay(day: -1, date: dateToInsert ?? Date.init()))
        }
        
        return monthDays
    }
    
    /// Creates an entire Month that precedes a given date.
    func createPreviousMonth(for date: Date = .init()) -> [Date.MonthDay] {
        let startOfFirstDate = calendar.startOfDay(for: date)
        
        guard let previousDate = calendar.date(byAdding: .day, value: -1, to: startOfFirstDate) else {
            return []
        }
        
        return fetchMonth(for: previousDate)
    }
    
    /// Creates an entire Month that follows a given date.
    func createNextMonth(for date: Date = .init()) -> [Date.MonthDay] {
        let startOfLastDate = calendar.startOfDay(for: date)
        
        guard let nextDate = calendar.date(byAdding: .day, value: 1, to: startOfLastDate) else {
            return []
        }
        
        return fetchMonth(for: nextDate)
    }
}

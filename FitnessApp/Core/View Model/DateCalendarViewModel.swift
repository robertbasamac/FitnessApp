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
    @Published var weekSelectedDate: Date = .init()
    @Published var weekSlider: [[Date.WeekDay]] = []
    @Published var currentWeekIndex: Int = 1
    @Published var createWeek: Bool = false
    
    // Calendar View Month Slider properties
    @Published var monthSelectedDate: Date = .init()
    @Published var monthSlider: [[Date.MonthDay]] = []
    @Published var currentMonthIndex: Int = 1
    @Published var createMonth: Bool = false
    
    @Published var weekDaysInitials: [Date.WeekDayInitial] = []
    
    private let calendar = Calendar.autoupdatingCurrent
    
    init() {
        generateWeeks()
        generateMonths()
        generateWeekDayInitials()
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
        
        weekSelectedDate = Date.init()
    }
    
    /// Updates the weeks displayed in the WeekSlider by creating new next/previous weeks and removing the older ones in order to always store and display the previous, current and next weeks.
    func updateWeeks() {
        if weekSlider.indices.contains(currentWeekIndex) {
            if let firstDate = weekSlider[currentWeekIndex].first?.date, currentWeekIndex == 0 {
                // Inserting Previous Week at 0th index and removing Next Week
                weekSlider.insert(createPreviousWeek(for: firstDate), at: 0)
                weekSlider.removeLast()
            }
        
            if let lastDate = weekSlider[currentWeekIndex].last?.date, currentWeekIndex == (weekSlider.count - 1) {
                // Inserting Next Week at 0th index and removing First Week
                weekSlider.append(createNextWeek(for: lastDate))
                weekSlider.removeFirst()
            }
            
            currentWeekIndex = 1
        }
        
        createWeek = false
    }
    
    /// Fetches an entire Week for a given Date.
    private func fetchWeek(for date: Date = .init()) -> [Date.WeekDay] {
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
    private func createPreviousWeek(for date: Date = .init()) -> [Date.WeekDay] {
        let startOfFirstDate = calendar.startOfDay(for: date)
        
        guard let previousDate = calendar.date(byAdding: .day, value: -1, to: startOfFirstDate) else {
            return []
        }
        
        return fetchWeek(for: previousDate)
    }
    
    /// Creates an entire Week that follows a given date.
    private func createNextWeek(for date: Date = .init()) -> [Date.WeekDay] {
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
            monthSlider.append(createPreviousMonth(for: firstDateOfMonth))
        }
        
        monthSlider.append(currentMonth)
        
        if let lastDate = currentMonth.last?.date {
            monthSlider.append(createNextMonth(for: lastDate))
        }
        
        monthSelectedDate = Date.init()
    }
    
    /// Updates the weeks  displayed in the MonthSlider by creating new next/previous months and removing the older ones in order to always store and display the previous, current and next months.
    func updateMonths() {
        if monthSlider.indices.contains(currentMonthIndex) {
            if let firstDate = monthSlider[currentMonthIndex].first?.date, currentMonthIndex == 0 {
                // Inserting Previous Month at 0th index and removing Next Month
                monthSlider.insert(createPreviousMonth(for: firstDate), at: 0)
                monthSlider.removeLast()
            }
        
            if let lastDate = monthSlider[currentMonthIndex].last?.date, currentMonthIndex == (monthSlider.count - 1) {
                // Inserting Next Month at 0th index and removing First Month
                monthSlider.append(createNextMonth(for: lastDate))
                monthSlider.removeFirst()
            }
            
            currentMonthIndex = 1
        }
        
        createMonth = false
    }
    
    /// Fetches an entire Month for a given Date.
    private func fetchMonth(for date: Date = .init()) -> [Date.MonthDay] {
        let startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: date)) ?? Date.init()
        
        let range = calendar.range(of: .day, in: .month, for: startDate) ?? Range(0...31)

        // get month days as MonthDay(Int, Date)
        var monthDays =  range.compactMap { day -> Date.MonthDay in
            let date = calendar.date(byAdding: .day, value: day - 1, to: startDate) ?? Date.init()
            
            let day = calendar.component(.day, from: date)
            let monthDay = Date.MonthDay(day: day, date: date)

            return monthDay
        }
        
        let firstWeekDay = calendar.component(.weekday, from: startDate)
        let startOfDate = calendar.startOfDay(for: date)

        let weekForDate = calendar.dateInterval(of: .weekOfMonth, for: startOfDate)

        guard let startOfWeek = weekForDate?.start else {
            return monthDays
        }
        
        let startOfWeekDay = calendar.component(.weekday, from: startOfWeek)
        
        // compute how many dates should be added to fill the current month (before the first day of the month)
        let previousOffset = ((firstWeekDay - startOfWeekDay) + 7) % 7
        
        // insert previous month dates before the first day of the current month
        for _ in 0..<previousOffset {
            let dateToInsert = calendar.date(byAdding: .day, value: -1, to: monthDays.first?.date ?? Date.init())
            monthDays.insert(Date.MonthDay(day: -1, date: dateToInsert ?? Date.init()), at: 0)
        }
        
        // compute how many dates should be added to fill the current month (after the last day of the month)
        let nextOffset = 6 * 7 - (range.count + previousOffset)
        
        // insert next month dates after the last day of the current month
        for _ in 0..<nextOffset {
            let dateToInsert = calendar.date(byAdding: .day, value: 1, to: monthDays.last?.date ?? Date.init())
            monthDays.append(Date.MonthDay(day: -1, date: dateToInsert ?? Date.init()))
        }
        
        return monthDays
    }
    
    /// Creates an entire Month that precedes a given date.
    private func createPreviousMonth(for date: Date = .init()) -> [Date.MonthDay] {
        let startOfFirstDate = calendar.startOfDay(for: date)
        
        guard let previousDate = calendar.date(byAdding: .day, value: -1, to: startOfFirstDate) else {
            return []
        }
        
        return fetchMonth(for: previousDate)
    }
    
    /// Creates an entire Month that follows a given date.
    private func createNextMonth(for date: Date = .init()) -> [Date.MonthDay] {
        let startOfLastDate = calendar.startOfDay(for: date)
        
        guard let nextDate = calendar.date(byAdding: .day, value: 1, to: startOfLastDate) else {
            return []
        }
        
        return fetchMonth(for: nextDate)
    }
    
    private func generateWeekDayInitials() {
        if weekSlider.count > 0 {
            weekSlider.first?.forEach { day in
                let weekDay = Date.WeekDayInitial(weekDay: day.date.format("EEEEE"))
                weekDaysInitials.append(weekDay)
            }
        }
    }
}

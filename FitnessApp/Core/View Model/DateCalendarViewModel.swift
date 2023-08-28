//
//  DateModel.swift
//  FitnessApp
//
//  Created by Robert Basamac on 18.04.2022.
//

import Foundation
import SwiftUI

class DateCalendarViewModel: ObservableObject {
    
    // Properties used for HomeTabView
    @Published var currentDate: Date = .init()
    @Published var weekSlider: [[Date.WeekDay]] = []
    @Published var currentWeekIndex: Int = 1
    @Published var createWeek: Bool = false
    
    
    // Properties used for CalendarTabView
    @Published var date: Date = .init()
    
    private let calendar = Calendar.autoupdatingCurrent
    
    init() {
        generateWeeks()
    }
    
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
        
        currentDate = Date.init()
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
}

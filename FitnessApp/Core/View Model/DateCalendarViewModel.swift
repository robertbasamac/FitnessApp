//
//  DateModel.swift
//  FitnessApp
//
//  Created by Robert Basamac on 18.04.2022.
//

import Foundation
import SwiftUI

class DateCalendarViewModel: ObservableObject {
    
    @Published var currentDate: Date = .init()
    @Published var weekSlider: [[Date.WeekDay]] = []
    @Published var currentWeekIndex: Int = 1
    @Published var createWeek: Bool = false
    
    private let calendar = Calendar.autoupdatingCurrent
    
    init() {
        generateWeeks()
    }
    
    /// Generate and reset the weeks in the slider to the ones based on the current date (previous, current, next).
    func generateWeeks() {
        weekSlider.removeAll()
        
        let currentWeek = fetchWeek()
        
        if let firstDate = currentWeek.first?.date {
            weekSlider.append(createPreviousWeek(firstDate))
        }
        
        weekSlider.append(currentWeek)
        
        if let lastDate = currentWeek.last?.date {
            weekSlider.append(createNextWeek(lastDate))
        }
        
        currentDate = Date.init()
    }
    
    /// Updating the weeks displayed in the Slider by creating new next/previous weeks and removing the older ones in order to always store and display 3 weeks.
    func updateWeeks() {
        if weekSlider.indices.contains(currentWeekIndex) {
            if let firstDate = weekSlider[currentWeekIndex].first?.date, currentWeekIndex == 0 {
                /// Inserting Previous Week at 0th index and removing Next Week
                weekSlider.insert(createPreviousWeek(firstDate), at: 0)
                weekSlider.removeLast()
            }
        
            if let lastDate = weekSlider[currentWeekIndex].last?.date, currentWeekIndex == (weekSlider.count - 1) {
                /// Inserting Next Week at 0th index and removing First Week
                weekSlider.append(createNextWeek(lastDate))
                weekSlider.removeFirst()
            }
            
            currentWeekIndex = 1
        }
        
        createWeek = false
    }
    
    /// Fetching Week based on given Date.
    func fetchWeek(_ date: Date = .init()) -> [Date.WeekDay] {
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
    
    /// Creating Previous Week based on the first current week's Date
    func createPreviousWeek(_ day: Date = .init()) -> [Date.WeekDay] {
        let startOfFirstDate = calendar.startOfDay(for: day)
        
        guard let previousDate = calendar.date(byAdding: .day, value: -1, to: startOfFirstDate) else {
            return []
        }
        
         return fetchWeek(previousDate)
    }
    
    /// Creating Next Week based on the last current week's Date
    func createNextWeek(_ day: Date = .init()) -> [Date.WeekDay] {
        let startOfLastDate = calendar.startOfDay(for: day)
        
        guard let nextDate = calendar.date(byAdding: .day, value: 1, to: startOfLastDate) else {
            return []
        }
        
         return fetchWeek(nextDate)
    }

    /// Check if Self date is in the same day as a given Date.
    func isToday(date: Date) -> Bool {
        return calendar.isDate(currentDate, inSameDayAs: date)
    }
    
    /// Checking Two dates are same
    func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    func isSelectedDay(date: Date) -> Bool {
        return calendar.isDate(currentDate, inSameDayAs: date)
    }
}

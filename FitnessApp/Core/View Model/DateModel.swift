//
//  DateModel.swift
//  FitnessApp
//
//  Created by Robert Basamac on 18.04.2022.
//

import Foundation
import SwiftUI

class DateModel: ObservableObject {
    @Published var currentWeek: [Date] = []
    @Published var currentDay: Date = Date()
    @Published var selectedDay: Date = Date()
    
    @Published var displayedWeeks: [[Date]] = Array(repeating: [], count: 3)
    
    private let calendar = Calendar.autoupdatingCurrent
    
    private func fetchWeeks() {
        (-1...1).forEach { index in
            if let day = calendar.date(byAdding: .weekOfYear, value: index, to: currentDay) {
                
                if let week = calendar.dateInterval(of: .weekOfMonth, for: day) {
                    let firstWeekDay = week.start
                    
                    var tempWeek: [Date] = []
                    
                    (0...6).forEach { day in
                        if let weekday = calendar.date(byAdding: .day, value: day, to: firstWeekDay) {
                            tempWeek.append(weekday)
                        }
                    }
                    
                    displayedWeeks[index + 1] = tempWeek
                    
                    if let thisWeek = calendar.dateInterval(of: .weekOfMonth, for: currentDay) {
                        if week.start == thisWeek.start {
                            currentWeek = displayedWeeks[index + 1]
                        }
                    }
                }
            }
        }
    }
    
    private func fetchNextWeek() {
        if let day = calendar.date(byAdding: .weekOfYear, value: 2, to: selectedDay) {
            if let week = calendar.dateInterval(of: .weekOfMonth, for: day) {
                let firstWeekDay = week.start
                
                var tempWeek: [Date] = []
                
                (0...6).forEach { day in
                    if let weekday = calendar.date(byAdding: .day, value: day, to: firstWeekDay) {
                        tempWeek.append(weekday)
                    }
                }

                displayedWeeks.append(tempWeek)
                displayedWeeks.removeFirst()
            }
        }
    }
    
    private func fetchPreviousWeek() {
        if let day = calendar.date(byAdding: .day, value: -14, to: selectedDay) {
            if let week = calendar.dateInterval(of: .weekOfMonth, for: day) {
                let firstWeekDay = week.start
                
                var tempWeek: [Date] = []

                (0...6).forEach { day in
                    if let weekday = calendar.date(byAdding: .day, value: day, to: firstWeekDay) {
                        tempWeek.append(weekday)
                    }
                }
                
                displayedWeeks.removeLast()
                displayedWeeks.insert(tempWeek, at: 0)
            }
        }
    }
    
    func extractDate(date: Date, format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.string(from: date)
    }

    func isToday(date: Date) -> Bool {
        return calendar.isDate(currentDay, inSameDayAs: date)
    }
    
    func isSelectedDay(date: Date) -> Bool {
        return calendar.isDate(selectedDay, inSameDayAs: date)
    }
    
    func showCurrentWeek() {
        fetchWeeks()
        selectedDay = currentDay
    }
    
    func showNextWeek() {
        fetchNextWeek()
        currentWeek = displayedWeeks[1]
        
        if let day = calendar.date(byAdding: .day, value: 7, to: selectedDay) {
            selectedDay = day
        }
    }
    
    func showPreviousWeek() {
        fetchPreviousWeek()
        currentWeek = displayedWeeks[1]
        
        if let day = calendar.date(byAdding: .day, value: -7, to: selectedDay) {
            selectedDay = day
        }
    }
}

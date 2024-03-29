//
//  Date+Extensions.swift
//  FitnessApp
//
//  Created by Robert Basamac on 10.08.2023.
//

import SwiftUI

extension Date {
    /// Custom Date Format
    func format(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.string(from: self)
    }
    
    /// Returns `true` if the Self date is within today, as defined by the calendar and calendar's locale.
    ///
    /// - returns: `true` if the Self date is within today.
    var isToday: Bool {
        return Calendar.autoupdatingCurrent.isDateInToday(self)
    }
    
    /// Returns `true` if the Self date is within the same day as the given date, as defined by the calendar and calendar's locale.
    ///
    /// - parameter date: A date to check for containment.
    /// - returns: `true` if `Self` and `date` are in the same day.
    func isSameDayAs(_ date: Date) -> Bool {
        return Calendar.autoupdatingCurrent.isDate(self, inSameDayAs: date)
    }
    
    /// Returns `true` if the Self date is within the same month as the given date, as defined by the calendar and calendar's locale.
    ///
    /// - parameter date: A date to check for containment.
    /// - returns: `true` if `Self` and `date` are in the same month.
    func isSameMonthAs(_ date: Date) -> Bool {
        let calendar = Calendar.autoupdatingCurrent
        
        let currentMonth = calendar.dateComponents([.year, .month], from: self)
        let selectedMonth = calendar.dateComponents([.year, .month], from: date)
        
        return currentMonth.year == selectedMonth.year && currentMonth.month == selectedMonth.month
    }
    
    struct WeekDay: Identifiable {
        var id: UUID = .init()
        var date: Date
    }
    
    struct MonthDay: Identifiable {
        var id: UUID = .init()
        var day: Int
        var date: Date
    }
    
    struct WeekDayInitial: Identifiable {
        var id: UUID = .init()
        var weekDay: String
    }
}

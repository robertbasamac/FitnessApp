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
    
    /// Returns `true` if the Self date is within the same day the given date, as defined by the calendar and calendar's locale.
    ///
    /// - parameter date: A date to check for containment.
    /// - returns: `true` if `Self` and `date` are in the same day.
    func isSameDayAs(_ date: Date) -> Bool {
        return Calendar.autoupdatingCurrent.isDate(self, inSameDayAs: date)
    }
    
//    func getAllMonthDates() -> [Date] {
//        let calendar = Calendar.autoupdatingCurrent
//        
//        // getting start Date
//        let startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: self))!
//        print("startDate: \(startDate)")
//        
//        let range = calendar.range(of: .day, in: .month, for: startDate)!
//        
//        // getting date
//        return range.compactMap { day -> Date in
//            print(calendar.date(byAdding: .day, value: day - 1, to: startDate)!)
//            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
//        }
//    }
    
    struct WeekDay: Identifiable {
        var id: UUID = .init()
        var date: Date
    }
    
    struct MonthDay: Identifiable {
        var id: UUID = .init()
        var day: Int
        var date: Date
    }
}

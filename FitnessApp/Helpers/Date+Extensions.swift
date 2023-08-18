//
//  Date+Extensions.swift
//  FitnessApp
//
//  Created by Robert Basamac on 10.08.2023.
//

import SwiftUI

/// Date Extensions needed for building UI
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
    
    struct WeekDay: Identifiable {
        var id: UUID = .init()
        var date: Date
    }
}

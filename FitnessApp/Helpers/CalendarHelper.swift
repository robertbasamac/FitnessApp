//
//  CalendarHelper.swift
//  FitnessApp
//
//  Created by Robert Basamac on 28.08.2023.
//

import Foundation

class CalendarHelper {
    
    let calendar = Calendar.autoupdatingCurrent
    let dateFormatter = DateFormatter()
    
    func monthYearString(_ date: Date) -> String {
        dateFormatter.dateFormat = "LLL yyyy"
        return dateFormatter.string(from: date)
    }
    
    func plusMonth(_ date: Date) -> Date {
        return calendar.date(byAdding: .month, value: 1, to: date)!
    }
    
    func minusMonth(_ date: Date) -> Date {
        return calendar.date(byAdding: .month, value: -1, to: date)!
    }
    
    func daysInMonth(_ date: Date) -> Int {
        let range = calendar.range(of: .day, in: .month, for: date)!
        
        print("DaysInMonth: \(range.count)")
        
        return range.count
    }
    
    func daysOfMonth(_ date: Date) -> Int {
        let components = calendar.dateComponents([.day], from: date)
        
        print("DaysOfMonth: \(components.day!)")
        
        return components.day!
    }
    
    func firstOfMonth(_ date: Date) -> Date {
        let components = calendar.dateComponents([.year, .month], from: date)
    
        print("FirstOfMonth: \(calendar.date(from: components)!)")

        return calendar.date(from: components)!
    }
    
    func weekDay(_ date: Date) -> Int {
        let components = calendar.dateComponents([.weekday], from: date)
        
        print("WeekDay: \(components.weekday!)")

        return components.weekday! - 
    }
}

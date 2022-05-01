//
//  DateModel.swift
//  FitnessApp
//
//  Created by Robert Basamac on 18.04.2022.
//

import Foundation

class DateModel: ObservableObject {
    @Published var currentWeek: [Date] = []
    @Published var currentDay: Date = Date()
    
    private let calendar = Calendar.autoupdatingCurrent
    
    //MARK: - Initializing
    init() {
        fetchWeek()
    }
    
    func fetchWeek(offset: Int = 0) {
        if let day = calendar.date(byAdding: .day, value: offset * 7, to: currentDay) {
            currentDay = day
            
            let week = calendar.dateInterval(of: .weekOfMonth, for: day)
            
            guard let firstWeekDay = week?.start else {
                return
            }
            
            (1...7).forEach { day in
                if let weekday = calendar.date(byAdding: .day, value: day - 1, to: firstWeekDay) {
                    currentWeek.append(weekday)
                }
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
}

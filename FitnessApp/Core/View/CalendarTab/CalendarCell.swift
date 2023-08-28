//
//  CalendarCell.swift
//  FitnessApp
//
//  Created by Robert Basamac on 28.08.2023.
//

import SwiftUI

struct CalendarCell: View {
    
    @EnvironmentObject var dateModel: DateCalendarViewModel
    
    let count: Int
    let startingSpaces: Int
    let daysInMonth: Int
    let daysInPrevMonth: Int
    
    var body: some View {
        Text(monthStruct().day())
            .foregroundStyle(textColor(type: monthStruct().monthType))
            .hSpacing(.center)
            .vSpacing(.center)
    }
    
    func monthStruct() -> MonthStruct {
        let start = startingSpaces == 0 ? startingSpaces + 7 : startingSpaces
        
        if count <= start {
            let day = daysInPrevMonth + count - start
            return MonthStruct(monthType: MonthType.Previous, dayInt: day)
        } else if count - start > daysInMonth {
            let day = count - start - daysInMonth
            return MonthStruct(monthType: MonthType.Next, dayInt: day)
        }
        
        let day = count - start
        return MonthStruct(monthType: MonthType.Current, dayInt: day)
    }
    
    func textColor(type: MonthType) -> Color {
        return type == MonthType.Current ? Color.primary : Color.secondary
    }
}

#Preview {
    CalendarCell(count: 31, startingSpaces: 4, daysInMonth: 31, daysInPrevMonth: 30)
}

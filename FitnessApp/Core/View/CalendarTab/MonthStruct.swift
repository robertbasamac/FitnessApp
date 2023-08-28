//
//  MonthStruct.swift
//  FitnessApp
//
//  Created by Robert Basamac on 28.08.2023.
//

import Foundation

struct MonthStruct {
    var monthType: MonthType
    var dayInt: Int
    
    func day() -> String {
        return String(dayInt)
    }
}

enum MonthType {
    case Previous, Current, Next
}

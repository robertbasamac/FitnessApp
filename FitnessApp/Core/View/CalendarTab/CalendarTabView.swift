//
//  CalendarTabView.swift
//  FitnessApp
//
//  Created by Robert Basamac on 01.05.2022.
//

import SwiftUI

struct CalendarTabView: View {

    @EnvironmentObject var dateModel: DateCalendarViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    CustomDatePicker()
                }
                .vSpacing(.top)
            }
            .clipped()
        }
    }
}

struct CalendarTabView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarTabView()
            .environmentObject(WorkoutViewModel())
            .environmentObject(DateCalendarViewModel())
            .environmentObject(ViewRouter())
    }
}

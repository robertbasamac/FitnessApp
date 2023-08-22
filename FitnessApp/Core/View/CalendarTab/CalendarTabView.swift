//
//  CalendarTabView.swift
//  FitnessApp
//
//  Created by Robert Basamac on 01.05.2022.
//

import SwiftUI

struct CalendarTabView: View {

    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .center){
                    Text("Calendar")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
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

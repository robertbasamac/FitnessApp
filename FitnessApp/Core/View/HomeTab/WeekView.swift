//
//  WeekPreviewView.swift
//  FitnessApp
//
//  Created by Robert Basamac on 22.07.2022.
//

import SwiftUI

struct WeekView: View {
    @EnvironmentObject private var workoutManager: WorkoutViewModel
    @EnvironmentObject private var dateModel: DateCalendarViewModel
    
    @Environment(\.colorScheme) var colorScheme
        
    let week: [Date]
    
    var body: some View {
        HStack {
            ForEach(week, id: \.self) { day in
                VStack(spacing: 2) {
                    Text(dateModel.extractDate(date: day, format: "dd"))
                        .font(.headline)
                        .fontWeight(.semibold)
                    Text(dateModel.extractDate(date: day, format: "EE"))
                        .font(.callout)
                    Circle()
                        .fill(dateModel.isSelectedDay(date: day) ?
                              (colorScheme == .light ? Color.white : Color.black) :
                                (colorScheme == .light ? Color.black : Color.white))
                        .frame(width: 8, height: 8)
                        .opacity(workoutManager.hasWorkouts(forDate: dateModel.extractDate(date: day, format: "dd/MM/yyy")) ? 1 : 0)
                }
                .foregroundStyle(dateModel.isToday(date: day) ? .primary : .secondary)
                .foregroundColor(dateModel.isToday(date: day) ? .red
                                 : (dateModel.isSelectedDay(date: day) ?
                                    (colorScheme == .light ? Color.white : Color.black) :
                                        (colorScheme == .light ? Color.black : Color.white)))
                .frame(height: 75)
                .frame(maxWidth: .infinity)
                .background (
                    ZStack {
                        if dateModel.isSelectedDay(date: day) {
                            Capsule()
                                .fill(colorScheme == .light ? Color.black : Color.white)
                        }
                    }
                )
                .onTapGesture {
                    withAnimation {
                        dateModel.selectedDay = day
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct WeekPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        BaseView()
            .environmentObject(WorkoutViewModel())
            .environmentObject(DateCalendarViewModel())
            .environmentObject(ViewRouter())
    }
}

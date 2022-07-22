//
//  WeekPreviewView.swift
//  FitnessApp
//
//  Created by Robert Basamac on 22.07.2022.
//

import SwiftUI

struct WeekView: View {
    @EnvironmentObject private var workoutManager: WorkoutManager
    @EnvironmentObject private var dateModel: DateModel
    
    @Environment(\.colorScheme) var colorScheme
    
    @Namespace var animation
    
    let week: [Date]
    
    var body: some View {
        HStack {
            ForEach(week, id: \.self) { day in
                VStack() {
                    Text(dateModel.extractDate(date: day, format: "dd"))
                        .font(.system(size: 15))
                        .fontWeight(.semibold)
                    Text(dateModel.extractDate(date: day, format: "EE"))
                        .font(.system(size: 14))
                    Circle()
                        .fill(dateModel.isSelectedDay(date: day) ?
                              (colorScheme == .light ? Color.white : Color.black) :
                                (colorScheme == .light ? Color.black : Color.white))
                        .frame(width: 8, height: 8)
                        .opacity(workoutManager.hasWorkouts(for: dateModel.extractDate(date: day, format: "dd/MM/yyy")) ? 1 : 0)
                }
                .foregroundStyle(dateModel.isToday(date: day) ? .primary : .secondary)
                .foregroundColor(dateModel.isToday(date: day) ? .red
                                 : (dateModel.isSelectedDay(date: day) ?
                                    (colorScheme == .light ? Color.white : Color.black) :
                                        (colorScheme == .light ? Color.black : Color.white)))
                .frame(height: 80)
                .frame(maxWidth: .infinity)
                .background (
                    ZStack {
                        if dateModel.isSelectedDay(date: day) {
                            Capsule()
                                .fill(colorScheme == .light ? Color.black : Color.white)
                                .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                        }
                    }
                )
                .contentShape(Capsule())
                .onTapGesture {
                    withAnimation {
                        dateModel.selectedDay = day
                    }
                }
            }
        }
        .padding(.vertical, 5)
        .frame(maxWidth: .infinity)
        
    }
}

struct WeekPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        WeekView(week: Array(repeating: Date(), count: 7))
    }
}

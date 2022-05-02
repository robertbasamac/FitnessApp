//
//  PopUpMenu.swift
//  FitnessApp
//
//  Created by Robert Basamac on 01.05.2022.
//

import SwiftUI

struct PopUpMenu: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @EnvironmentObject var dateModel: DateModel
    
    let width, height: CGFloat
    
    var body: some View {
        HStack(alignment: .center, spacing: width) {
            ZStack {
                Circle()
                    .foregroundColor(.white)
                    .frame(width: width, height: width)
                    .shadow(color: .purple, radius: 10, x: 0, y: 0)
                Image(systemName: "play.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: width, height: width)
                    .foregroundColor(.purple)
            }
            .onTapGesture {
                
            }
            
            ZStack {
                Circle()
                    .foregroundColor(.white)
                    .frame(width: width, height: width)
                    .shadow(color: .purple, radius: 10, x: 0, y: 0)
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: width, height: width)
                    .foregroundColor(.purple)
            }
            .onTapGesture {
                workoutManager.addWorkout(Workout(title: "Workout"), for: dateModel.extractDate(date: dateModel.currentDay, format: "dd/ee/yyy"))
            }
        }
        .frame(height: height)
        .shadow(radius: 2)
        .transition(.scale)
    }
}

struct PopUpMenu_Previews: PreviewProvider {
    static var previews: some View {
        BaseView()
            .environmentObject(WorkoutManager())
            .environmentObject(DateModel())
            .environmentObject(ViewRouter())
    }
}

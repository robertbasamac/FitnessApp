//
//  HomeView.swift
//  FitnessApp
//
//  Created by Robert Basamac on 18.04.2022.
//

import SwiftUI

struct HomeView: View {
    @Namespace var animation
    @StateObject var dateModel = DateModel()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {

            LazyVStack(spacing: 10, pinnedViews: [.sectionHeaders]) {
                
                Section {
                    
                    //MARK: - Week View
                    ScrollView(.horizontal, showsIndicators: false) {
                        
                        HStack(spacing: 10) {
                            
                            ForEach(dateModel.currentWeek, id: \.self) { day in
                                
                                VStack(spacing: 10) {
                                    // EEE will return day number
                                    Text(dateModel.extractDate(date: day, format: "dd"))
                                        .font(.system(size: 15))
                                        .fontWeight(.semibold)
                                    
                                    // EEE will return day as MON, TUE ...
                                    Text(dateModel.extractDate(date: day, format: "EEE"))
                                        .font(.system(size: 14))
                                    
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 8, height: 8)
                                        .opacity(dateModel.isToday(date: day) ? 1 : 0)
                                }
                                // Foreground Style
                                .foregroundStyle(dateModel.isToday(date: day) ? .primary : .tertiary)
                                .foregroundColor(dateModel.isToday(date: day) ? .white : .black)
                                
                                // Capsule Shape
                                .frame(width: 45, height: 90)
                                .background (
                                    ZStack {
                                        // Matched Geometry Effect
                                        if dateModel.isToday(date: day) {
                                            Capsule()
                                                .fill(.black)
                                                .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                                        }
                                    }
                                )
                                .contentShape(Capsule())
                                .onTapGesture {
                                    // Updating Current Day
                                    withAnimation {
                                        dateModel.currentDay = day
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity)
                    }
                } header: {
                    HeaderView()
                }
            }
        }
        .clipped()
    }
    
    func HeaderView() -> some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 15) {
                Text(Date().formatted(date: .abbreviated, time: .omitted))
                    .foregroundColor(.gray)
                
                Text(dateModel.extractDate(date: Date(), format: "EEEE"))
                    .font(.largeTitle.bold())
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Button {
                
            } label: {
                Image("Profile")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 45, height: 45)
                    .clipShape(Circle())
            }
        }
        .padding()
        .background(Color.white)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

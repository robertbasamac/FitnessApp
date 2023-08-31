//
//  CalendarTabView.swift
//  FitnessApp
//
//  Created by Robert Basamac on 01.05.2022.
//

import SwiftUI

struct CalendarTabView: View {

    @EnvironmentObject var dateModel: DateCalendarViewModel
        
    @State private var tabHeight: CGFloat = 100

    var body: some View {
        VStack(spacing: 0) {
            HeaderView()
            
            Divider()
            
            ScrollView(.vertical) {
                VStack {
                    Text("Sroll View Test")
                }
                .padding()
                .vSpacing(.top)
                .hSpacing(.center)
            }
        }
        .clipped()
    }
}

extension CalendarTabView {
    
    // MARK: - HeaderView
    
    @ViewBuilder
    func HeaderView() -> some View {
        VStack(spacing: 4) {
            
            // Current Month Header
            HStack(spacing: 40) {
                
                HStack(spacing: 10) {
                    Text(Date.init().format("MMMM"))
                        .foregroundStyle(.red)
                    Text(Date.init().format("yyyy"))
                }
                .font(.title.weight(.semibold))

                
                Spacer()
                
                Button(action: {
                    dateModel.currentMonthIndex -= 1
                }, label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                })
                
                Button(action: {
                    dateModel.currentMonthIndex += 1
                }, label: {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                })
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 8)
            
            // Week Days initials
            HStack(alignment: .center, spacing: 0) {
                ForEach(dateModel.weekSlider[dateModel.currentWeekIndex]) { day in
                    Text(day.date.format("EEEEE"))
                        .font(.callout.weight(.regular))
                        .textScale(.secondary)
                }
                .hSpacing(.center)
            }
            
            // Month Slider
            TabView(selection: $dateModel.currentMonthIndex, content:  {
                ForEach(dateModel.monthSlider.indices, id: \.self) { index in
                    MonthView(dateModel.monthSlider[index])
                        .tag(index)
                        .background {
                            GeometryReader { geometry in
                                Color.clear
                                    .preference(key: TabViewHeightPreference.self, value: geometry.frame(in: .local).height)
                            }
                        }
                }
            })
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(minHeight: 100)
            .frame(height: tabHeight)
            .onPreferenceChange(TabViewHeightPreference.self) { height in
                self.tabHeight = height
            }
        }
    }
    
    // MARK: - MonthView
    
    @ViewBuilder
    func MonthView(_ month: [Date.MonthDay]) -> some View {
        let columns = Array(repeating: GridItem(.flexible()), count: 7)
        
        LazyVGrid(columns: columns, content: {
            ForEach(dateModel.monthSlider[dateModel.currentMonthIndex]) { date in
                DayCardView(date: date)
                    .onTapGesture {
                        print(date.date.description)
                    }
            }
        })
//        .background {
//            GeometryReader {
//                let minX = $0.frame(in: .global).minX
//                
//                Color.clear
//                    .preference(key: OffsetKey.self, value: minX)
//                    .onPreferenceChange(OffsetKey.self) { value in
//                        /// When the offset reaches 15 and if the createWeek is toggled then simply generate next set of weeks
//                        if value.rounded() == 0 && dateModel.createWeek {
//                            dateModel.updateWeeks()
//                        }
//                    }
//            }
//        }
    }
    
    // MARK: - DayCardView
    @ViewBuilder
    func DayCardView(date: Date.MonthDay) -> some View {
        VStack(spacing: 0) {
            Text("\(date.date.format("d"))")
                .font(.title3)
                .foregroundStyle(date.day == -1 ? .secondary : .primary)
        }
        .frame(height: 45, alignment: .top)
        .hSpacing(.center)
    }
}

// MARK: - Preview

struct CalendarTabView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarTabView()
            .environmentObject(WorkoutViewModel())
            .environmentObject(DateCalendarViewModel())
            .environmentObject(ViewRouter())
    }
}

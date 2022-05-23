//
//  TitleView.swift
//  FitnessApp
//
//  Created by Robert Basamac on 11.05.2022.
//

import SwiftUI

struct AEWTitleSectionView: View {
    @Binding var workout: Workout
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .background(Color(uiColor: .systemGray))
            
            VStack(spacing: 0) {
                TextField("Title", text: $workout.title)
                    .frame(height: 40)
                
                Divider()
                    .background(Color(uiColor: .systemGray))
                
                TextField("Description", text: $workout.description)
                    .frame(height: 40)
                    .font(.system(size: 16))
                    .foregroundStyle(.secondary)
            }
            .padding(.leading, 20)
            .background(Color(uiColor: .tertiarySystemBackground))
            
            Divider()
                .background(Color(uiColor: .systemGray))
        }
        .padding(.bottom, 40)
    }
}

struct WorkoutTitleView_Previews: PreviewProvider {
    static var previews: some View {
        BaseView()
            .environmentObject(WorkoutManager())
            .environmentObject(DateModel())
            .environmentObject(ViewRouter())
    }
}


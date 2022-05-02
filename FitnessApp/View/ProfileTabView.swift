//
//  ProfileTabView.swift
//  FitnessApp
//
//  Created by Robert Basamac on 01.05.2022.
//

import SwiftUI

struct ProfileTabView: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .center){
                Text("Profile")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .clipped()
    }
}

struct ProfileTabView_Previews: PreviewProvider {
    static var previews: some View {
        BaseView()
            .environmentObject(WorkoutManager())
            .environmentObject(DateModel())
            .environmentObject(ViewRouter())
    }
}

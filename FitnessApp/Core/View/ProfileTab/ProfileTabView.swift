//
//  ProfileTabView.swift
//  FitnessApp
//
//  Created by Robert Basamac on 01.05.2022.
//

import SwiftUI

struct ProfileTabView: View {
    
    @State private var editAppIcon: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .center){
                    Text("Profile")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .clipped()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        editAppIcon.toggle()
                    } label: {
                        Image(systemName: "apps.iphone")
                    }
                }
            }
            .sheet(isPresented: $editAppIcon) {
                ChangeAppIconView()
            }
        }
    }
}

struct ProfileTabView_Previews: PreviewProvider {
    static var previews: some View {
        BaseView()
            .environmentObject(WorkoutViewModel())
            .environmentObject(DateCalendarViewModel())
            .environmentObject(ViewRouter())
    }
}

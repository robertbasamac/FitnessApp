//
//  HeaderView.swift
//  FitnessApp
//
//  Created by Robert Basamac on 27.04.2022.
//

import SwiftUI

struct HeaderView: View {
    @EnvironmentObject var dateModel: DateModel
    
    var body: some View {
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
        .background {
            Color(uiColor: .systemBackground)
        }
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
            .environmentObject(DateModel())
    }
}

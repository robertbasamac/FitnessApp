//
//  EmptyView.swift
//  FitnessApp
//
//  Created by Robert Basamac on 24.09.2022.
//

import SwiftUI

struct EmptyView: View {
    var body: some View {
        Text("No workouts assigned.")
            .font(.subheadline)
            .foregroundColor(.red)
            .frame(maxWidth: .infinity)
    }
}

struct EmptyView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}

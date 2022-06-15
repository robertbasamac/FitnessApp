//
//  WCSetSectionView.swift
//  FitnessApp
//
//  Created by Robert Basamac on 12.06.2022.
//

import SwiftUI

struct WCSetSectionView: View {
    @Binding var exercise: Exercise

    var body: some View {
        ForEach(exercise.sets.indices, id: \.self) { setIndex in
            HStack {
                Text("Set \(setIndex + 1)")
                    .font(.callout)
                
                Spacer()
                
                if exercise.type == .repBased {
                    VStack {
                        Text("reps")
                            .font(.caption2)
                            .foregroundStyle(.secondary)

                        Text("\(exercise.sets[setIndex].reps)")
                            .font(.footnote)
                    }
                    
                    Spacer()
                } else {
                    VStack {
                        Text("time (s)")
                            .font(.caption2)
                            .foregroundStyle(.secondary)

                        Text("\(exercise.sets[setIndex].duration)")
                            .font(.footnote)
                        
                        Spacer()
                    }
                }
                
                VStack {
                    Text("weight (Kg)")
                        .font(.caption2)
                        .foregroundStyle(.secondary)

                    Text("\(exercise.sets[setIndex].weight, specifier: "%.1f")")
                        .font(.footnote)
                }
                
                Spacer()
                
                VStack {
                    Text("rest (s)")
                        .font(.caption2)
                        .foregroundStyle(.secondary)

                    Text("\(exercise.sets[setIndex].rest)")
                        .font(.footnote)
                }
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 2)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(uiColor: .systemBackground))
            }
        }
    }
}

struct WCSetSectionView_Previews: PreviewProvider {
    static var previews: some View {
        BaseView()
            .environmentObject(WorkoutManager())
            .environmentObject(DateModel())
            .environmentObject(ViewRouter())
    }
}

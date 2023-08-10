//
//  ExerciseCardView.swift
//  FitnessApp
//
//  Created by Robert Basamac on 17.07.2022.
//

import SwiftUI

struct ExerciseCardView: View {
    
    @Binding var exercise: ExerciseModel
    @State var expandExercise: Bool = false
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        LazyVStack(alignment: .leading, spacing: 8, pinnedViews: .sectionHeaders) {
            Section {
                if expandExercise {
                    setsSection
                }
            } header: {
                titleSection
            }
        }
        .padding(.horizontal, 8)
        .padding(.bottom, 8)
        .padding(.top, 6)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(uiColor: .systemFill))
        }
        .onTapGesture {
            withAnimation {
                expandExercise.toggle()
            }
        }
        .onDisappear {
            expandExercise = false
        }
    }
}

//MARK: - Content Views

extension ExerciseCardView {
    
    private var titleSection:  some View {
        VStack(alignment: .leading) {
            Text(exercise.title)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(expandExercise ?
                                 (colorScheme == .light ? Color.white : Color.black)
                                 : Color(uiColor: .label))
            
            if exercise.instructions.count > 0 {
                Text(exercise.instructions)
                    .font(.caption)
                    .foregroundColor(expandExercise ?
                                     (colorScheme == .light ? Color.white : Color.black)
                                     : Color(uiColor: .label))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 3)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            if expandExercise {
                Color(uiColor: colorScheme == .light ? .black : .white)
            }
        }
        .cornerRadius(10)
        .shadow(color: colorScheme == .light ?
                    Color.black.opacity(expandExercise ? 0.6 : 0) :
                    Color.white.opacity(expandExercise ? 0.6 : 0),
                radius: 10,
                x: 0, y: 0)
        .padding(.top, 2)
    }
    
    private var setsSection: some View {
        
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
                } else {
                    VStack {
                        Text("time (s)")
                            .font(.caption2)
                            .foregroundStyle(.secondary)

                        Text("\(exercise.sets[setIndex].duration)")
                            .font(.footnote)
                    }
                }
                
                Spacer()

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
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(uiColor: .systemBackground))
            }
        }
    }
}

struct ExerciseCardView_Previews: PreviewProvider {
    static var previews: some View {
        BaseView()
            .environmentObject(WorkoutViewModel())
            .environmentObject(DateCalendarViewModel())
            .environmentObject(ViewRouter())
    }
}

//
//  WorkoutCardView.swift
//  FitnessApp
//
//  Created by Robert Basamac on 23.05.2022.
//

import SwiftUI

struct WorkoutCardView: View {
    @Binding var workout: Workout
    @State var expandWorkout: Bool = false
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        LazyVStack(alignment: .leading, pinnedViews: .sectionHeaders) {
            Section {
                if self.expandWorkout {
                    self.exercisesAndSetsSection()
                }
            } header: {
                self.titleSection()
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
                self.expandWorkout.toggle()
            }
        }
        .onDisappear {
            self.expandWorkout = false
        }
    }
}

//MARK: - Extension to create WorkoutCardView content
extension WorkoutCardView {
    
    private func titleSection() ->  some View {
        VStack(alignment: .leading) {
            Text(workout.title)
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(expandWorkout ?
                                 (colorScheme == .light ? Color.white : Color.black)
                                 : Color(uiColor: .label))
            
            if workout.description.count > 0 {
                Text(workout.description)
                    .font(.caption)
                    .foregroundColor(expandWorkout ?
                                     (colorScheme == .light ? Color.white : Color.black)
                                     : Color(uiColor: .label))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 8)
        .padding(.bottom, 4)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            if expandWorkout {
                Color(uiColor: colorScheme == .light ? .black : .white)
            }
        }
        .cornerRadius(10)
        .shadow(color: colorScheme == .light ?
                    Color.black.opacity(expandWorkout ? 0.6 : 0) :
                    Color.white.opacity(expandWorkout ? 0.6 : 0),
                radius: 10,
                x: 0, y: 0)
        .padding(.top, 2)
    }
    
    private func exercisesAndSetsSection() -> some View {
        
        ForEach(workout.exercises.indices, id: \.self) { exerciseIndex in
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 20) {
                    Text("\(exerciseIndex + 1)")
                        .font(.headline)
                        .foregroundColor(colorScheme == .light ? Color.white: Color.black)
                        .padding(.horizontal)
                        .padding(.vertical, 2)
                        .background {
                            Circle()
                                .foregroundColor(colorScheme == .light ? Color.black: Color.white)
                        }
                    
                    Text(workout.exercises[exerciseIndex].title)
                        .font(.title3)
                }
                .padding(.horizontal)
                
                VStack {
                    setsSection(exercise: workout.exercises[exerciseIndex])
                }
            }
            .padding(.all, 8)
            .background {
//                Color(uiColor: .secondarySystemFill)
//                    .cornerRadius(10)
//                    .shadow(color: Color(uiColor: .white).opacity(0.3),
//                            radius: 10,
//                            x: 0, y: 0)
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(uiColor: .secondarySystemFill))
            }
        }
    }
    
    private func setsSection(exercise: Exercise) -> some View {
        
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

struct WorkoutCardView_Previews: PreviewProvider {
    static var previews: some View {
        BaseView()
            .environmentObject(WorkoutManager())
            .environmentObject(DateModel())
            .environmentObject(ViewRouter())
    }
}

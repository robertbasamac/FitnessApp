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
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(workout.title)
                    .font(.title)
                if workout.description.count > 0 {
                    Text(workout.description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                }
                
                if expandWorkout {
                    ForEach($workout.exercises) { exercise in
                        Text(exercise.title.wrappedValue)
                            .font(.title3)
                        
                        VStack {
                            ForEach(0..<exercise.sets.count, id: \.self) { setIndex in
                                HStack {
                                    Text("Set \(setIndex + 1)")

                                    Spacer()
                                    
                                    VStack {
                                        Text("reps")
                                        Text("\(exercise.sets[setIndex].wrappedValue.reps)")
                                    }
                                    Spacer()
                                    VStack {
                                        Text("time")
                                        Text("\(exercise.sets[setIndex].wrappedValue.duration)")
                                    }
                                    Spacer()
                                    VStack {
                                        Text("weight")
                                        Text("\(exercise.sets[setIndex].wrappedValue.weight, specifier: "%.2f")")
                                    }
                                }
                            }
                        }
                        .padding(.leading)
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            
            Spacer()
        }
        .frame(maxWidth: UIScreen.main.bounds.width - 50)
        .padding(.all)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(uiColor: .systemFill))
        )
        .onTapGesture {
            withAnimation {
                expandWorkout.toggle()
            }
        }
    }
}

struct WorkoutCardView_Previews: PreviewProvider {
    static var previews: some View {
//        WorkoutCardView(workout: Workout(title: "Legs day",
//                                         description: "Workout legs like hell. Multiple exercises with multiple sets.",
//                                         exercises: [
//                                             Exercise(title: "Leg press",
//                                                      type: .repBased,
//                                                      sets: [
//                                                         Set(weight: 5, reps: 10),
//                                                         Set(weight: 10, reps: 8),
//                                                         Set(weight: 15, reps: 5)
//                                                      ]),
//                                             Exercise(title: "Lunges",
//                                                      type: .repBased,
//                                                      sets: [
//                                                         Set(weight: 400, reps: 10),
//                                                         Set(weight: 60, reps: 10),
//                                                         Set(weight: 100, reps: 10),
//                                                         Set(weight: 3, reps: 10)
//                                                      ])
//                                         ]), expandWorkout: true)
        BaseView()
            .environmentObject(WorkoutManager())
            .environmentObject(DateModel())
            .environmentObject(ViewRouter())
    }
}

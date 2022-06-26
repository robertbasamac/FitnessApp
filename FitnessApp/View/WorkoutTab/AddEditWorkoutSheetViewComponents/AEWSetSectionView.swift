//
//  SetView.swift
//  FitnessApp
//
//  Created by Robert Basamac on 11.05.2022.
//

import SwiftUI

struct AEWSetSectionView: View {
    @Binding var exercise: Exercise
    
    var body: some View {
        ForEach(exercise.sets.indices, id: \.self) { setIndex in
            HStack(spacing: 0) {
                HStack(spacing: 20) {
                    RemoveSetButton(exercise: $exercise, index: setIndex)
                    
                    Text("Set \(setIndex + 1)")
                        .frame(height: 40)
                }
                
                VStack(spacing: 0) {
                    if exercise.type == .repBased {
                        Stepper(value: $exercise.sets[setIndex].reps, in: 1...Int.max, step: 1) {
                            Text("\(exercise.sets[setIndex].reps) rep(s)")
                                .frame(height: 40)
                        }
                    } else {
                        Stepper(value: $exercise.sets[setIndex].duration, in: 1...Int.max, step: 1) {
                            Text("\(exercise.sets[setIndex].duration) second(s)")
                                .frame(height: 40)
                        }
                    }
                    
                    Divider()
                        .background(Color(uiColor: .systemGray))
                    
                    AdjustWeightView(set: $exercise.sets[setIndex])
                    
                    Divider()
                        .background(Color(uiColor: .systemGray))
                    
                    Stepper(value: $exercise.sets[setIndex].rest, in: 0...Int.max, step: 1) {
                        Text("\(exercise.sets[setIndex].rest) second(s)")
                            .frame(height: 40)
                    }
                }
                .padding(.horizontal, 20)
            }
            
            Divider()
                .background(Color(uiColor: .systemGray))
        }
    }
}

struct AddSetButton: View {
    @Binding var exercise: Exercise
    
    var body: some View {
        Button {
            exercise.sets.append(Set())
        } label: {
            HStack(spacing: 20) {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.green)
                    .background {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 10, height: 10)
                    }
                Text("add set")
            }
            .frame(maxWidth: .infinity, minHeight: 40, alignment: .leading)
        }
    }
}

struct RemoveSetButton: View {
    @Binding var exercise: Exercise
    
    let index: Int
    
    var body: some View {
        Button {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            
            exercise.sets.remove(at: index)
        } label: {
            HStack(spacing: 0) {
                Image(systemName: "minus.circle.fill")
                    .foregroundColor(.red)
                    .background {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 10, height: 10)
                    }
            }
        }
    }
}

struct AdjustWeightView: View {
    @Binding var set: Set
    
    var body: some View {
        HStack(spacing: 20) {
            VStack(alignment: .center, spacing: 15) {
                Text("Weight")
                Text(String(format: "%.1f", set.weight))
                Text("Kg")
            }
            
            VStack(spacing: 5) {
                Stepper(value: $set.weight, in: 0...999, step: 20) {
                    HStack(spacing: 0) {
                        Spacer()
                        Text("20 Kg")
                    }
                }
                Stepper(value: $set.weight, in: 0...999, step: 10) {
                    HStack(spacing: 0) {
                        Spacer()
                        Text("10 Kg")
                    }
                }
                Stepper(value: $set.weight, in: 0...999, step: 5) {
                    HStack(spacing: 0) {
                        Spacer()
                        Text("5 Kg")
                    }
                }
                Stepper(value: $set.weight, in: 0...999, step: 2.5) {
                    HStack(spacing: 0) {
                        Spacer()
                        Text("2.5 Kg")
                    }
                }
                Stepper(value: $set.weight, in: 0...999, step: 0.5) {
                    HStack(spacing: 0) {
                        Spacer()
                        Text("0.5 Kg")
                    }
                }
            }
        }
        .padding(.vertical, 5)
    }
}

struct SetView_Previews: PreviewProvider {
    static var previews: some View {
        BaseView()
            .environmentObject(WorkoutManager())
            .environmentObject(DateModel())
            .environmentObject(ViewRouter())
    }
}

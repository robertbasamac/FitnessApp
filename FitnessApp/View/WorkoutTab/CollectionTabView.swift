//
//  CollectionTabView.swift
//  FitnessApp
//
//  Created by Robert Basamac on 15.07.2022.
//

import SwiftUI

struct CollectionTabView: View {
    
    @State private var selectedPage: CollectionPage = .exercises
    
    @State private var showCreateExercise: Bool = false
    @State private var showCreateWorkout: Bool = false
    
    @State private var editWorkout: Bool = false
    @State private var editExercise: Bool = false
    
    enum CollectionPage: String, Identifiable, CaseIterable {
        var id: Self { self }
        
        case workouts = "Workouts"
        case exercises = "Exercises"
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("", selection: $selectedPage.animation()) {
                    ForEach(CollectionPage.allCases, id: \.self) { value in
                        Text(value.rawValue)
                            .tag(value)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 8)
                .padding(.bottom, 8)
                
                switch selectedPage {
                case .workouts:
                    WorkoutsTabView()
                        .transition(.asymmetric(
                            insertion: .move(edge: .leading),
                            removal: .move(edge: .trailing)))
                case .exercises:
                    ExercisesTabView()
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing),
                        removal: .move(edge: .leading)))
                }
            }
            .navigationTitle("Collection")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button {
                            editWorkout = false
                            
                            withAnimation {
                                selectedPage = .workouts
                                showCreateWorkout.toggle()
                            }
                        } label: {
                            Text("Create Workout")
                        }
                        .accessibilityLabel("Create new Workout")
                        
                        Button {
                            editExercise = false
                            
                            withAnimation {
                                selectedPage = .exercises
                                showCreateExercise.toggle()
                            }
                        } label: {
                            Text("Create Exercise")
                        }
                        .accessibilityLabel("Create new Exercise")
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showCreateWorkout) {
                CreateWorkoutSheetView(editWorkout: $editWorkout)
            }
            .sheet(isPresented: $showCreateExercise) {
                CreateExerciseSheetView(editExercise: $editExercise)
            }
        }
    }
}

struct CollectionTabView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionTabView()
            .environmentObject(WorkoutManager())
            .environmentObject(DateModel())
    }
}

//
//  CollectionTabView.swift
//  FitnessApp
//
//  Created by Robert Basamac on 15.07.2022.
//

import SwiftUI

struct CollectionTabView: View {
    
    @State private var selectedPage: CollectionPage = .workouts
    
    enum CollectionPage: String, Identifiable, CaseIterable {
        var id: Self { self }
        
        case workouts = "Workouts"
        case exercises = "Exercises"
    }
    
    // Handling sheets presentation
    enum Sheet: String, Identifiable {
        case createWorkout, createExercise

        var id: String { rawValue }
    }
    @State private var presentedSheet: Sheet?

    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                switch selectedPage {
                case .workouts:
                    WorkoutsTabView()
                        .transition(.move(edge: .leading))
                case .exercises:
                    ExercisesTabView()
                        .transition(.move(edge: .trailing))
                }
            }
            .navigationTitle("Collection")
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Picker("Select Page", selection: $selectedPage.animation()) {
                        ForEach(CollectionPage.allCases, id: \.self) { value in
                            Text(value.rawValue)
                                .tag(value)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button {
                            withAnimation {
                                selectedPage = .workouts
                            }
                            presentedSheet = .createWorkout
                        } label: {
                            Text("Create Workout")
                        }
                        
                        Button {
                            withAnimation {
                                selectedPage = .exercises
                            }
                            presentedSheet = .createExercise
                        } label: {
                            Text("Create Exercise")
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(item: $presentedSheet) { sheet in
                switch sheet {
                case .createWorkout:
                    CreateWorkoutSheetView()
                        .interactiveDismissDisabled()
                case .createExercise:
                    CreateExerciseSheetView()
                        .interactiveDismissDisabled()
                }
            }
        }
    }
}

struct CollectionTabView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionTabView()
            .environmentObject(WorkoutViewModel())
            .environmentObject(DateCalendarViewModel())
    }
}

//
//  ViewRouter.swift
//  FitnessApp
//
//  Created by Robert Basamac on 01.05.2022.
//

import SwiftUI

class ViewRouter: ObservableObject {
    @Published var currentTab: Page = .home
}

enum Page: String, CaseIterable, Identifiable {
    var id: Self { self }
    
    case home
    case calendar
    
    case popup
    
    case workouts
    case profile
    
    var systemImageName: String {
        switch self {
        case .home:
            return "house"
        case .calendar:
            return "calendar"
            
        case .popup:
            return "popup"
            
        case .workouts:
            return "list.bullet.rectangle"
        case .profile:
            return "person"
        }
    }
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .calendar:
            return "Calendar"
            
        case .popup:
            return "Popup"
            
        case .workouts:
            return "Workouts"
        case .profile:
            return "Profile"
        }
    }
}

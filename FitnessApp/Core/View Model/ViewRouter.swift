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

enum Page: String, Identifiable {
    var id: Self { self }
    
    case home = "Home"
    case calendar = "Calendar"
    case collection = "Collection"
    case profile = "Profile"
    
//    var systemImageName: String {
//        switch self {
//        case .home:
//            return "house"
//        case .calendar:
//            return "calendar"
//        case .collection:
//            return "list.bullet.rectangle"
//        case .profile:
//            return "person"
//        }
//    }
//
//    var title: String {
//        switch self {
//        case .home:
//            return "Home"
//        case .calendar:
//            return "Calendar"
//        case .collection:
//            return "Collection"
//        case .profile:
//            return "Profile"
//        }
//    }
}

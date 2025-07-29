//
//  ThemeConstants.swift
//  Duelist
//
//  Created by Sebastian on 7/27/25.
//

import Foundation

struct ThemeConstants {
    // "Dark" removed for now too many ui nits to be picked atm.
    static let availableThemes = ["Default", "Forest"]
    
    static func getBackgroundImage(for theme: String) -> String {
        switch theme {
        case "Default":
            return "background_default"
        case "Dark":
            return "background_dark"
        case "Forest":
            return "background_forest"
        default:
            return "background_default"
        }
    }
}

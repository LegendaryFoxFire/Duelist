//
//  ThemeConstants.swift
//  Duelist
//
//  Created by Sebastian on 7/27/25.
//

import Foundation

struct ThemeConstants {
    static let availableThemes = ["Default", "Forest"] // "Dark" removed for now too many ui nits to be picked atm.
    
    static func getBackgroundImage(for theme: String) -> String {
        switch theme {
        case "Default":
            return "background_default"
        case "Dark":
            return "background_dark"
        case "Forest":
            return "background_forest"
        case "Light":
            return "background_default"  // Placeholder until you add this asset
        case "Ocean":
            return "background_default"  // Placeholder until you add this asset
        default:
            return "background_default"
        }
    }
}

//
//  AppTheme.swift
//  Duelist
//
//  Created by John Bukoski on 7/16/25.
//

import SwiftUI
import Foundation

enum ThemeColors {
    // Keep these as fallbacks
    static let primary = Color.primary
    static let secondary = Color.secondary
    static let accent = Color.accentColor
    static let background = Color(UIColor.systemBackground)
    static let foreground = Color(UIColor.label)
    
    // Add dynamic theme-aware colors
    static func getPrimary(for theme: String) -> Color {
        switch theme {
        case "Dark":
            return .white
        case "Forest":
            return .white
        default:
            return .black
        }
    }
    
    static func getSecondary(for theme: String) -> Color {
        switch theme {
        case "Dark":
            return Color.gray.opacity(0.8)
        case "Forest":
            return Color.green.opacity(0.7)
        default:
            return Color.secondary
        }
    }
    
    static func getAccent(for theme: String) -> Color {
        switch theme {
        case "Dark":
            return Color.blue.opacity(0.6)  // Reduced from 0.9 to 0.6 for less glow
        case "Forest":
            return Color.green
        default:
            return Color.blue
        }
    }
    
    static func getBackground(for theme: String) -> Color {
        switch theme {
        case "Dark":
            return Color.black.opacity(0.8)
        case "Forest":
            return Color.green.opacity(0.1)
        default:
            return Color(UIColor.systemBackground)
        }
    }
    
    static func getForeground(for theme: String) -> Color {
        switch theme {
        case "Dark":
            return .white
        case "Forest":
            return .white
        case "Default":
            return .white
        default:
            return .white
        }
    }
    
    // Add this new function for text field text color
    static func getTextFieldText(for theme: String) -> Color {
        switch theme {
        case "Dark":
            return .black  // Black text in text fields for dark mode
        case "Forest":
            return .black  // Black text in text fields for forest mode
        default:
            return .black  // Black text for all themes
        }
    }
    
    // Helper methods that automatically get current user's theme
    static func dynamicPrimary(authManager: AuthManager) -> Color {
        let theme = authManager.user?.theme ?? "Default"
        return getPrimary(for: theme)
    }
    
    static func dynamicSecondary(authManager: AuthManager) -> Color {
        let theme = authManager.user?.theme ?? "Default"
        return getSecondary(for: theme)
    }
    
    static func dynamicAccent(authManager: AuthManager) -> Color {
        let theme = authManager.user?.theme ?? "Default"
        return getAccent(for: theme)
    }
    
    static func dynamicBackground(authManager: AuthManager) -> Color {
        let theme = authManager.user?.theme ?? "Default"
        return getBackground(for: theme)
    }
    
    static func dynamicForeground(authManager: AuthManager) -> Color {
        let theme = authManager.user?.theme ?? "Default"
        return getForeground(for: theme)
    }
    
    // Add this helper for text field text
    static func dynamicTextFieldText(authManager: AuthManager) -> Color {
        let theme = authManager.user?.theme ?? "Default"
        return getTextFieldText(for: theme)
    }
}

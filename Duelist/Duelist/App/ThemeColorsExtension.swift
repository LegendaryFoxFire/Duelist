//
//  ThemeColors+Extensions.swift
//  Duelist
//
//  Created by Sebastian on 7/27/25.
//

import SwiftUI

extension ThemeColors {
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
}

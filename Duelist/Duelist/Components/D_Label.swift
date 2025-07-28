//
//  D_Label.swift
//  Duelist
//
//  Created by Sam on 18/07/25.
//

import SwiftUI

struct D_Label: View {
    @EnvironmentObject var authManager: AuthManager  // Add for theme awareness
    var title: String
    var fontSize: CGFloat

    var body: some View {
        Text(title)
            .foregroundStyle(ThemeColors.dynamicPrimary(authManager: authManager))  // Dynamic theme-aware color instead of .black
            .font(.custom("Copperplate", size: fontSize))
            .foregroundColor(ThemeColors.dynamicAccent(authManager: authManager))  // Dynamic theme-aware accent color instead of .yellow
            .shadow(radius: 3)
    }
}

#Preview {
    D_Label(title: "Title", fontSize: 24)
        .font(.title)
}

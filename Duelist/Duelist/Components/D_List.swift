//
//  D_List.swift
//  Duelist
//
//  Created by Sam on 25/07/25.
//

import SwiftUI

struct D_List<Content: View>: View {
    @EnvironmentObject var authManager: AuthManager  // Add for theme awareness
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        List {
            content
        }
        .listStyle(.plain) // or whatever style you prefer
        .listRowInsets(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 0))
        .scrollContentBackground(.hidden) // iOS 16+
        .background(Color.clear)
        .foregroundColor(ThemeColors.dynamicPrimary(authManager: authManager))  // Add theme-aware text color
    }
}

struct D_ListRow<Content: View>: View {
    @EnvironmentObject var authManager: AuthManager  // Add for theme awareness
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .font(.headline)
            .foregroundColor(ThemeColors.dynamicPrimary(authManager: authManager))  // Add theme-aware text color
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .scrollContentBackground(.hidden)
            .background(Color.clear)
            .cornerRadius(10)
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
    }
}

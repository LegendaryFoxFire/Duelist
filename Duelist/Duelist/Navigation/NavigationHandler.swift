//
//  NavigationHandler.swift
//  Duelist
//
//  Created by John Bukoski on 7/19/25.
//

import SwiftUI

/// A shared navigation controller for switching between top-level screens.
class NavigationHandler: ObservableObject {
    /// The currently active page of the app.
    @Published var currentPage: NavigationPage = .title

    /// A static helper to perform animated page changes with spring animation.
    static func animatePageChange(_ change: @escaping () -> Void) {
        #warning("Change duration to 0.7~ for production")
        withAnimation(.easeInOut(duration: 0.05), change)
    }
    
    /// Optional: Adds a transition helper if you want animation or tracking.
    func go(to page: NavigationPage) {
        withAnimation(.easeInOut(duration: 0.4)) {
            self.currentPage = page
        }
    }
}

//
//  DuelistApp.swift
//  Duelist
//
//  Created by John Bukoski on 7/15/25.
//

import SwiftUI

@main
struct DuelistApp: App {
    @StateObject var navHandler = NavigationHandler()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(navHandler)
                .environmentObject(CurrentUserManager.shared)
                .environmentObject(GlobalUsersManager.shared)
        }
    }
}

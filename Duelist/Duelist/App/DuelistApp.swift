//
//  DuelistApp.swift
//  Duelist
//
//  Created by John Bukoski on 7/15/25.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct DuelistApp: App {
    @StateObject var navHandler = NavigationHandler()
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(navHandler)
                .environmentObject(CurrentUserManager.shared)
                .environmentObject(GlobalUsersManager.shared)
        }
    }
}

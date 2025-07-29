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
      AudioManager.shared.setupAudioSession()

    return true
  }
}

@main
struct DuelistApp: App {
    @StateObject var navHandler = NavigationHandler()
    @StateObject private var authManager = AuthManager()
    @StateObject private var notificationManager = NotificationManager.shared
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(navHandler)
                .environmentObject(FirebaseService.shared)
                .environmentObject(authManager)
                .environmentObject(notificationManager)
                .onAppear {
                    setupNotifications()
                    
                    // Give Firebase time to load, then start music for new users if needed
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        if authManager.user == nil {
                            AudioManager.shared.playLoopingMusic(named: "Through the Mystic Woods")
                        }
                    }
                }
                .onChange(of: authManager.user) { oldUser, newUser in
                    // Handle music when user auth state changes
                    handleMusicForCurrentUser()
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                    // App is going to background
                    handleAppGoingToBackground()
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                    // App became active
                    handleAppBecameActive()
                }
        }
    }
    
    // notifications functions
    
    private func setupNotifications() {
        Task {
            await notificationManager.requestPermission()
        }
    }
    
    private func handleAppGoingToBackground() {
        AudioManager.shared.stopMusic()
        // Only schedule if notifications are enabled in user settings
        if authManager.user?.notificationsOn == true {
            let interval = authManager.user?.reminderInterval ?? 30  // Use user's preference or default to 30
            notificationManager.scheduleReminderNotification(after: interval)
        }
    }
    
    private func handleAppBecameActive() {
        notificationManager.cancelReminderNotifications()
        notificationManager.clearBadge()
        
        // Handle music based on current user state
        handleMusicForCurrentUser()
    }
    
    private func handleMusicForCurrentUser() {
        let shouldPlayMusic = authManager.user?.volumeOn ?? true
        
        if shouldPlayMusic {
            AudioManager.shared.playLoopingMusic(named: "Through the Mystic Woods")
        } else {
            AudioManager.shared.stopMusic()
        }
    }
}

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
    @State private var isLoading = true
    
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            Group {
                if isLoading {
                    LoadingSpinnerView()
                } else {
                    ContentView()
                        .environmentObject(navHandler)
                        .environmentObject(FirebaseService.shared)
                        .environmentObject(authManager)
                        .environmentObject(notificationManager)
                }
            }
            .onAppear {
                setupNotifications()
                startInitialSetup()
            }
            .onChange(of: authManager.user) { oldUser, newUser in
                // Handle music when user auth state changes
                handleMusicForCurrentUser()
                
                // Handle navigation based on auth state
                handleNavigationForAuthState(oldUser: oldUser, newUser: newUser)
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
    
    private func startInitialSetup() {
        Task {
            do {
                // Wait for Firebase auth to determine user state
                try await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds
            } catch {
                // If sleep fails, just continue immediately
                print("Sleep interrupted, proceeding with setup")
            }
            
            await MainActor.run {
                completeInitialSetup()
            }
        }
    }

    private func completeInitialSetup() {
        // Set initial navigation based on auth state
        if authManager.user != nil {
            navHandler.currentPage = .mainMenu
        } else {
            navHandler.currentPage = .title
        }
        
        // Start music if appropriate
        let shouldPlayMusic = authManager.user?.volumeOn ?? true
        if shouldPlayMusic {
            AudioManager.shared.playLoopingMusic(named: "Through the Mystic Woods")
        }
        
        // Hide loading screen
        withAnimation(.easeOut(duration: 0.5)) {
            isLoading = false
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
    
    // Handle navigation based on authentication state
    private func handleNavigationForAuthState(oldUser: User?, newUser: User?) {
        // Only handle changes after initial loading is done
        guard !isLoading else { return }
        
        // If user just logged in, always go to main menu
        if oldUser == nil && newUser != nil {
            NavigationHandler.animatePageChange {
                navHandler.currentPage = .mainMenu
            }
        }
        
        // If user logged out, go back to title screen
        if oldUser != nil && newUser == nil {
            NavigationHandler.animatePageChange {
                navHandler.currentPage = .title
            }
        }
    }
}

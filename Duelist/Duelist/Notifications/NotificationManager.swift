//
//  NotificationManager.swift
//  Duelist
//
//  Created by Sebastian on 7/27/25.
//


import UserNotifications

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    private init() {}
    
    // Request notification permission
    func requestPermission() async -> Bool {
        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(
                options: [.alert, .badge, .sound]
            )
            return granted
        } catch {
            print("Failed to request notification permission: \(error)")
            return false
        }
    }
    
    // Schedule a reminder notification
    func scheduleReminderNotification(after minutes: Int = 30) {
        let content = UNMutableNotificationContent()
        content.title = "Come back to Duelist!"
        content.body = "Ready for another duel? Your opponents are waiting!"
        content.sound = .default
        content.badge = 1
        
        // Create trigger for the specified minutes
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: TimeInterval(minutes * 60),
            repeats: false
        )
        
        // Create request
        let request = UNNotificationRequest(
            identifier: "duelist-reminder",
            content: content,
            trigger: trigger
        )
        
        // Schedule the notification
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error)")
            } else {
                print("Notification scheduled for \(minutes) minutes from now")
            }
        }
    }
    
    // Cancel pending notifications
    func cancelReminderNotifications() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: ["duelist-reminder"]
        )
    }
    
    // Clear badge when app becomes active
    func clearBadge() {
        UNUserNotificationCenter.current().setBadgeCount(0)
    }
}

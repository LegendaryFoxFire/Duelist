//
//  DataModels.swift
//  Duelist
//
//  Created by Sebastian on 7/23/25.
//

import Foundation
import FirebaseFirestore

// Represents both the user profile and their social graph.
struct User: Identifiable, Codable, Hashable {
    @DocumentID var id: String?                  // Firestore document ID (same as Firebase UID)
    
    var userID: String                    // Firebase UID (for redundancy & lookups)
    var username: String                            // Display name or username
    var numberOfWins: Int                        // Total wins in the game
    var sword: String                            // Currently equipped sword
    var profilePicture: Int                      // Avatar index or asset ID
    
    var useCustomProfileImage: Bool
    var customProfileImageURL: String?
    
    var volumeOn: Bool
    var theme: String
    var notificationsOn: Bool
    var reminderInterval: Int?
    
    // Social graph (reference by UID)
    var friendsListIDs: [String]
    var friendRequestIDs: [String]
    var sentFriendRequestIDs: [String]
    
    // Computed property to get reminder interval with default
    var actualReminderInterval: Int {
        return reminderInterval ?? 30 // Default to 30 minutes
    }

}

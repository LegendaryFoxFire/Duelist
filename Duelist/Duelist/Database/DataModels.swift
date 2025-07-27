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
    
    // Social graph (reference by UID)
    var friendsListIDs: [String]
    var friendRequestIDs: [String]
    var sentFriendRequestIDs: [String]
    
    // MARK: - Custom Decoding
    // This handles cases where database entries might be missing newer fields
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode required fields (these should always exist)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        userID = try container.decode(String.self, forKey: .userID)
        username = try container.decode(String.self, forKey: .username)
        numberOfWins = try container.decode(Int.self, forKey: .numberOfWins)
        sword = try container.decode(String.self, forKey: .sword)
        profilePicture = try container.decode(Int.self, forKey: .profilePicture)
        friendsListIDs = try container.decode([String].self, forKey: .friendsListIDs)
        friendRequestIDs = try container.decode([String].self, forKey: .friendRequestIDs)
        sentFriendRequestIDs = try container.decode([String].self, forKey: .sentFriendRequestIDs)
        
        // Decode newer fields with fallback defaults (for existing users who don't have these fields)
        volumeOn = try container.decodeIfPresent(Bool.self, forKey: .volumeOn) ?? true
        theme = try container.decodeIfPresent(String.self, forKey: .theme) ?? "background_0"
        notificationsOn = try container.decodeIfPresent(Bool.self, forKey: .notificationsOn) ?? true
        
        // Decode newest fields
        customProfileImageURL = try container.decodeIfPresent(String.self, forKey: .customProfileImageURL)
        useCustomProfileImage = try container.decodeIfPresent(Bool.self, forKey: .useCustomProfileImage) ?? true
    }
    
    // MARK: - Regular Initializer
    // This is for creating new User instances in your code
    init(
        id: String? = nil,
        userID: String,
        username: String,
        numberOfWins: Int,
        sword: String,
        profilePicture: Int,
        useCustomProfileImage: Bool = true,
        customProfileImageURL: String? = nil,
        volumeOn: Bool = true,
        theme: String = "background_0",
        notificationsOn: Bool = true,
        friendsListIDs: [String],
        friendRequestIDs: [String],
        sentFriendRequestIDs: [String]
    ) {
        self.id = id
        self.userID = userID
        self.username = username
        self.numberOfWins = numberOfWins
        self.sword = sword
        self.profilePicture = profilePicture
        self.useCustomProfileImage = useCustomProfileImage
        self.customProfileImageURL = customProfileImageURL
        self.volumeOn = volumeOn
        self.theme = theme
        self.notificationsOn = notificationsOn
        self.friendsListIDs = friendsListIDs
        self.friendRequestIDs = friendRequestIDs
        self.sentFriendRequestIDs = sentFriendRequestIDs
    }
}

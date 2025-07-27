//
//  FirebaseService.swift
//  Duelist
//
//  Created by Sebastian on 7/23/25.
//

import Foundation
import Firebase
import FirebaseStorage

class FirebaseService: ObservableObject {
    
    static let shared = FirebaseService()
    private let db = Firestore.firestore()
    
    @Published var users: [User] = []
    
    private init() {}

     // MARK: - Create a new User profile
     func createUserProfile(uid: String, email: String) {
         let username = email.components(separatedBy: "@").first ?? "User"
         let newUser = User(
             id: uid,
             userID: uid,
             username: username,
             numberOfWins: 0,
             sword: "sword_0_tp",
             profilePicture: 0,
             customProfileImageURL: nil,
             volumeOn: true,
             theme: "background_0",
             notificationsOn: true,
             friendsListIDs: [],
             friendRequestIDs: [],
             sentFriendRequestIDs: []
         )
         saveUser(newUser)
     }

     // MARK: - Save (create or update) User document
    func saveUser(_ user: User) {
        do {
            print("Saving user to Firestore: \(user.username) (UID: \(user.userID))")
            try db.collection("users").document(user.userID).setData(from: user)
            print("User saved successfully!")
        } catch {
            print("Failed to save user: \(error)")
        }
    }

     // MARK: - Fetch a single User by ID
     func getUser(by id: String, completion: @escaping (Result<User, Error>) -> Void) {
         let docRef = db.collection("users").document(id)
         docRef.getDocument { snapshot, error in
             if let error = error {
                 completion(.failure(error))
                 return
             }
             do {
                 if let user = try snapshot?.data(as: User.self) {
                     completion(.success(user))
                 } else {
                     completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not found"])))
                 }
             } catch {
                 completion(.failure(error))
             }
         }
     }

     // MARK: - Fetch multiple Users from a list of IDs
     func fetchUsers(forIDs ids: [String], completion: @escaping ([User]) -> Void) {
         var fetchedUsers: [User] = []
         let group = DispatchGroup()

         for id in ids {
             group.enter()
             db.collection("users").document(id).getDocument { snapshot, _ in
                 defer { group.leave() }
                 if let snapshot = snapshot, let user = try? snapshot.data(as: User.self) {
                     fetchedUsers.append(user)
                 }
             }
         }

         group.notify(queue: .main) {
             completion(fetchedUsers)
         }
     }

     // MARK: - Send a friend request
     func sendFriendRequest(from senderID: String, to receiverID: String) {
         getUser(by: receiverID) { result in
             switch result {
             case .success(var receiver):
                 if !receiver.friendRequestIDs.contains(senderID) {
                     receiver.friendRequestIDs.append(senderID)
                     self.saveUser(receiver)
                 }
             case .failure(let error):
                 print("Error sending friend request: \(error)")
             }
         }

         getUser(by: senderID) { result in
             switch result {
             case .success(var sender):
                 if !sender.sentFriendRequestIDs.contains(receiverID) {
                     sender.sentFriendRequestIDs.append(receiverID)
                     self.saveUser(sender)
                 }
             case .failure(let error):
                 print("Error updating sender: \(error)")
             }
         }
     }

     // MARK: - Accept a friend request
     func acceptFriendRequest(currentUserID: String, requesterID: String) {
         getUser(by: currentUserID) { result in
             switch result {
             case .success(var user):
                 if user.friendRequestIDs.contains(requesterID) {
                     user.friendRequestIDs.removeAll { $0 == requesterID }
                     user.friendsListIDs.append(requesterID)
                     self.saveUser(user)
                 }
             case .failure(let error):
                 print("Error updating current user: \(error)")
             }
         }

         getUser(by: requesterID) { result in
             switch result {
             case .success(var requester):
                 if !requester.friendsListIDs.contains(currentUserID) {
                     requester.friendsListIDs.append(currentUserID)
                     requester.sentFriendRequestIDs.removeAll { $0 == currentUserID }
                     self.saveUser(requester)
                 }
             case .failure(let error):
                 print("Error updating requester: \(error)")
             }
         }
     }
    
    func fetchUserProfile(uid: String) async throws -> User {
        let docRef = db.collection("users").document(uid)
        let snapshot = try await docRef.getDocument()
        
        guard let user = try? snapshot.data(as: User.self) else {
            throw NSError(domain: "FirebaseService", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found"])
        }
        
        return user
    }
    
    func createUserProfileAsync(uid: String, email: String) async throws -> User {
        let username = email.components(separatedBy: "@").first ?? "User"
        let newUser = User(
            id: uid,
            userID: uid,
            username: username,
            numberOfWins: 0,
            sword: "sword_0_tp",
            profilePicture: 0,
            customProfileImageURL: nil,
            volumeOn: true,
            theme: "background_0",
            notificationsOn: true,
            friendsListIDs: [],
            friendRequestIDs: [],
            sentFriendRequestIDs: []
        )
        
        try db.collection("users").document(uid).setData(from: newUser)
        return newUser
    }
    
    // Add this method to your FirebaseService class
    func saveUserAsync(_ user: User) async throws {
        try await db.collection("users").document(user.userID).setData(from: user)
    }
    
    // Add to FirebaseService.swift
    func getUserRank(for userID: String) async throws -> Int {
        // Get all users sorted by wins
        let snapshot = try await db.collection("users")
            .order(by: "numberOfWins", descending: true)
            .getDocuments()
        
        // Find the user's position
        for (index, document) in snapshot.documents.enumerated() {
            if document.documentID == userID {
                return index + 1
            }
        }
        
        return snapshot.documents.count + 1 // Last place if not found
    }
    
    func sendFriendRequestAsync(from senderID: String, to receiverID: String) async throws {
        // Update receiver
        let receiver = try await fetchUserProfile(uid: receiverID)
        var updatedReceiver = receiver
        if !updatedReceiver.friendRequestIDs.contains(senderID) {
            updatedReceiver.friendRequestIDs.append(senderID)
            try await saveUserAsync(updatedReceiver)
        }
        
        // Update sender
        let sender = try await fetchUserProfile(uid: senderID)
        var updatedSender = sender
        if !updatedSender.sentFriendRequestIDs.contains(receiverID) {
            updatedSender.sentFriendRequestIDs.append(receiverID)
            try await saveUserAsync(updatedSender)
        }
    }

    func acceptFriendRequestAsync(currentUserID: String, requesterID: String) async throws {
        // Update current user
        let currentUser = try await fetchUserProfile(uid: currentUserID)
        var updatedCurrentUser = currentUser
        updatedCurrentUser.friendRequestIDs.removeAll { $0 == requesterID }
        if !updatedCurrentUser.friendsListIDs.contains(requesterID) {
            updatedCurrentUser.friendsListIDs.append(requesterID)
        }
        try await saveUserAsync(updatedCurrentUser)
        
        // Update requester
        let requester = try await fetchUserProfile(uid: requesterID)
        var updatedRequester = requester
        if !updatedRequester.friendsListIDs.contains(currentUserID) {
            updatedRequester.friendsListIDs.append(currentUserID)
        }
        updatedRequester.sentFriendRequestIDs.removeAll { $0 == currentUserID }
        try await saveUserAsync(updatedRequester)
    }
    
    func fetchAllUsers() async throws -> [User] {
        let snapshot = try await db.collection("users").getDocuments()
        return snapshot.documents.compactMap { document in
            try? document.data(as: User.self)
        }
    }
    
    // Add to FirebaseService.swift
    func uploadProfileImage(_ image: UIImage, for userID: String) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.7) else {
            throw NSError(domain: "FirebaseService", code: 400, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data"])
        }
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imageRef = storageRef.child("profile_images/\(userID).jpg")
        
        // Upload the image
        let _ = try await imageRef.putDataAsync(imageData)
        
        // Get download URL
        let downloadURL = try await imageRef.downloadURL()
        return downloadURL.absoluteString
    }
}


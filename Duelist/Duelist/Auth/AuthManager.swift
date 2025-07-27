import Foundation
import Firebase
import FirebaseAuth

class AuthManager: ObservableObject {
    @Published var user: User?  // Your custom User type
    @Published var firebaseUser: FirebaseAuth.User?  // Firebase Auth user
    @Published var isAuthenticated = false
    @Published var isLoading = false
    
    private let firebaseService = FirebaseService.shared
    
    init() {
        Auth.auth().addStateDidChangeListener { _, firebaseUser in
            Task { @MainActor in
                self.firebaseUser = firebaseUser
                self.isAuthenticated = firebaseUser != nil
                
                if let firebaseUser = firebaseUser {
                    await self.loadUserProfile(uid: firebaseUser.uid)
                } else {
                    self.user = nil
                }
            }
        }
    }
    
    // In AuthManager.loadUserProfile()
    @MainActor
    private func loadUserProfile(uid: String) async {
        do {
            print("Trying to load user profile for UID: \(uid)")
            self.isLoading = true
            let user = try await firebaseService.fetchUserProfile(uid: uid)
            print("Found existing user: \(user.username)")
            self.user = user
        } catch {
            print("❌ User profile not found: \(error)")
            print("🆕 Creating new user profile...")
            if let firebaseUser = self.firebaseUser {
                self.createNewUserProfile(firebaseUser: firebaseUser)
            }
        }
        self.isLoading = false
    }
    
    // In AuthManager.createNewUserProfile()
    private func createNewUserProfile(firebaseUser: FirebaseAuth.User) {
        print("Creating new user profile for: \(firebaseUser.uid)")
        let email = firebaseUser.email ?? ""
        firebaseService.createUserProfile(uid: firebaseUser.uid, email: email)
        
        Task {
            await self.loadUserProfile(uid: firebaseUser.uid)
        }
    }
    func signUp(email: String, password: String) async throws {
        try await Auth.auth().createUser(withEmail: email, password: password)
        // Auth state listener will handle the rest
    }
    
    func signIn(email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password)
        // Auth state listener will handle the rest
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
        // Auth state listener will handle clearing the user
    }
    
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    @MainActor
    func updateUser(_ updatedUser: User) async throws {
        try await firebaseService.saveUserAsync(updatedUser)
        self.user = updatedUser
    }
    
    @MainActor
    func sendFriendRequest(to receiverID: String) async throws {
        guard let currentUser = user else { throw NSError(domain: "AuthManager", code: 401, userInfo: [NSLocalizedDescriptionKey: "No current user"]) }
        
        try await firebaseService.sendFriendRequest(from: currentUser.userID, to: receiverID)
        
        // Update local user
        var updatedUser = currentUser
        if !updatedUser.sentFriendRequestIDs.contains(receiverID) {
            updatedUser.sentFriendRequestIDs.append(receiverID)
            self.user = updatedUser
        }
    }

    @MainActor
    func acceptFriendRequest(from requesterID: String) async throws {
        guard let currentUser = user else { throw NSError(domain: "AuthManager", code: 401, userInfo: [NSLocalizedDescriptionKey: "No current user"]) }
        
        try await firebaseService.acceptFriendRequest(currentUserID: currentUser.userID, requesterID: requesterID)
        
        // Update local user
        var updatedUser = currentUser
        updatedUser.friendRequestIDs.removeAll { $0 == requesterID }
        if !updatedUser.friendsListIDs.contains(requesterID) {
            updatedUser.friendsListIDs.append(requesterID)
        }
        self.user = updatedUser
    }

    @MainActor
    func rejectFriendRequest(from requesterID: String) async throws {
        guard let currentUser = user else { throw NSError(domain: "AuthManager", code: 401, userInfo: [NSLocalizedDescriptionKey: "No current user"]) }
        
        var updatedUser = currentUser
        updatedUser.friendRequestIDs.removeAll { $0 == requesterID }
        
        try await updateUser(updatedUser)
    }

    @MainActor
    func loadFriends() async throws -> [User] {
        guard let currentUser = user else { return [] }
        
        return await withCheckedContinuation { continuation in
            firebaseService.fetchUsers(forIDs: currentUser.friendsListIDs) { friends in
                continuation.resume(returning: friends)
            }
        }
    }

    @MainActor
    func loadFriendRequests() async throws -> [User] {
        guard let currentUser = user else { return [] }
        
        return await withCheckedContinuation { continuation in
            firebaseService.fetchUsers(forIDs: currentUser.friendRequestIDs) { requests in
                continuation.resume(returning: requests)
            }
        }
    }

    @MainActor
    func loadSentFriendRequests() async throws -> [User] {
        guard let currentUser = user else { return [] }
        
        return await withCheckedContinuation { continuation in
            firebaseService.fetchUsers(forIDs: currentUser.sentFriendRequestIDs) { sentRequests in
                continuation.resume(returning: sentRequests)
            }
        }
    }
    
    @MainActor
    func loadAllUsers() async throws -> [User] {
        // You'll need to add this method to FirebaseService
        return try await firebaseService.fetchAllUsers()
    }
    
    @MainActor
    func getUserRank(for userID: String) async throws -> Int {
        return try await firebaseService.getUserRank(for: userID)
    }
    
    @MainActor
    func uploadCustomProfileImage(_ image: UIImage) async throws {
        guard let currentUser = user else {
            throw NSError(domain: "AuthManager", code: 401, userInfo: [NSLocalizedDescriptionKey: "No current user"])
        }
        
        // Upload image to Firebase Storage
        let imageURL = try await firebaseService.uploadProfileImage(image, for: currentUser.userID)
        
        // Update user with new image URL
        var updatedUser = currentUser
        updatedUser.customProfileImageURL = imageURL
        
        try await updateUser(updatedUser)
    }
}

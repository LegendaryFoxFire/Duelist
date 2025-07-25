//
//  AuthManager.swift
//  Duelist
//
//  Created by Sebastian on 7/23/25.
//

import Foundation
import Firebase
import FirebaseAuth

class AuthManager: ObservableObject {
    @Published var user: User?
    @Published var isAuthenticated = false
    @Published var isLoading = false
    
    init() {
        // Listen for auth state changes
        Auth.auth().addStateDidChangeListener { _, user in
            self.user = user
            self.isAuthenticated = user != nil
        }
    }
    
    func signUp(email: String, password: String) async throws {
        try await Auth.auth().createUser(withEmail: email, password: password)
    }
    
    func signIn(email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
}

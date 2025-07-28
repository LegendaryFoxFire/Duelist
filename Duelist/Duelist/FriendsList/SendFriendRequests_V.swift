//
//  SendFriendRequests_V.swift
//  Duelist
//
//  Created by Sam on 22/07/25.
//

import SwiftUI

struct SendFriendRequests_V: View {
    @EnvironmentObject var nav: NavigationHandler
    @EnvironmentObject var authManager: AuthManager
    
    @State private var searchText: String = ""
    @State private var allUsers: [User] = []
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var sendingRequests: Set<String> = []
    
    // Users who can receive friend requests (excluding current friends, pending requests, etc.)
    var potentialNewFriends: [User] {
        guard let currentUser = authManager.user else { return [] }
        
        return allUsers.filter { user in
            // Exclude self
            user.userID != currentUser.userID &&
            // Exclude current friends
            !currentUser.friendsListIDs.contains(user.userID) &&
            // Exclude users who already sent requests to current user
            !currentUser.friendRequestIDs.contains(user.userID) &&
            // Exclude users current user already sent requests to
            !currentUser.sentFriendRequestIDs.contains(user.userID)
        }
    }
    
    var filteredPotentialNewFriends: [User] {
        if searchText.isEmpty {
            return potentialNewFriends
        } else {
            return potentialNewFriends.filter {
                $0.username.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    var body: some View {
        D_Background {
            BackButton(label: "Friends List", destination: .friendsList) {
                VStack {
                    D_Label(title: "Add New Friends", fontSize: Globals.LargeTitleFontSize)
                    
                    if isLoading {
                        ProgressView("Loading users...")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        D_List {
                            VStack{
                                D_TextField(text: $searchText, type: .search, keyword: "Search users")
                                
                                if filteredPotentialNewFriends.isEmpty {
                                    VStack {
                                        Text(searchText.isEmpty ? "No users available" : "No users found")
                                            .font(.title2)
                                            .foregroundColor(.secondary)
                                        Text(searchText.isEmpty ?
                                             "All users are either your friends or have pending requests." :
                                                "Try searching for a different username.")
                                        .font(.body)
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.center)
                                    }
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(Color.clear)
                                    
                                } else {
                                    ForEach(filteredPotentialNewFriends, id: \.id) { user in
                                        D_ListRow {
                                            HStack {
                                                Button(action: {
                                                    nav.currentPage = .otherProfile(user: user, source: .sendFriendRequests)
                                                }) {
                                                    HStack {
                                                        ProfilePhotoHelper.getProfileImageView(for: user, size: .small)
                                                        D_Label(title: user.username, fontSize: Globals.HeadingFontSize)
                                                    }
                                                }
                                                .buttonStyle(.plain)
                                                
                                                Spacer()
                                                
                                                if sendingRequests.contains(user.userID) {
                                                    ProgressView()
                                                        .scaleEffect(0.8)
                                                } else {
                                                    Button("Add") {
                                                        Task {
                                                            await sendFriendRequest(to: user)
                                                        }
                                                    }
                                                    .buttonStyle(BorderlessButtonStyle())
                                                    .padding()
                                                }
                                            }
                                        }
                                    }
                                    
                                }
                            }
                            .listRowBackground(Color.clear)
                        }
                        .background(Color.clear)
                    }
                }
            }
        }
        .task {
            await loadAllUsers()
        }
        .alert("Error", isPresented: $showError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
        
    
    private func loadAllUsers() async {
        isLoading = true
        
        do {
            allUsers = try await authManager.loadAllUsers()
        } catch {
            errorMessage = "Failed to load users: \(error.localizedDescription)"
            showError = true
        }
        
        isLoading = false
    }
    
    private func sendFriendRequest(to user: User) async {
        sendingRequests.insert(user.userID)
        
        do {
            try await authManager.sendFriendRequest(to: user.userID)
            
            // Show success feedback (optional)
            // You could add a toast or temporary message here
        } catch {
            errorMessage = "Failed to send friend request: \(error.localizedDescription)"
            showError = true
        }
        
        sendingRequests.remove(user.userID)
    }
}

#Preview {
    SendFriendRequests_V()
}

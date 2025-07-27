//
//  FriendsList_V.swift
//  Duelist
//
//  Created by Sam on 19/07/25.
//

import SwiftUI

struct FriendsList_V: View {
    @EnvironmentObject var nav: NavigationHandler
    @EnvironmentObject var authManager: AuthManager
    
    @State private var friends: [User] = []
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        D_Background {
            BackButton(label: "Main Menu", destination: .mainMenu) {
                VStack {
                    D_Label(title: "Friends", fontSize: Globals.LargeTitleFontSize)
                    
                    // Navigation buttons to friend requests
                    HStack(spacing: 20) {
                        D_Button(action: {
                            nav.currentPage = .sendFriendRequests
                        }) {
                            Text("Send Requests")
                        }
                        
                        D_Button(action: {
                            nav.currentPage = .friendRequests
                        }) {
                            Text("View Requests")
                        }
                    }
                    .padding(.vertical)
                    
                    if isLoading {
                        ProgressView("Loading friends...")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if friends.isEmpty {
                        VStack {
                            Text("No friends yet")
                                .font(.title2)
                                .foregroundColor(.secondary)
                            Text("Send friend requests to connect with other players!")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        D_List {
                            ForEach(friends, id: \.id) { friend in
                                D_ListRow {
                                    FriendListRow(friend: friend)
                                }
                            }
                        }
                    }
                    
                    Spacer()
                }
            }
            .padding(.top, 10)
        }
        .task {
            await loadFriends()
        }
        .alert("Error", isPresented: $showError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func loadFriends() async {
        isLoading = true
        
        do {
            friends = try await authManager.loadFriends()
        } catch {
            errorMessage = "Failed to load friends: \(error.localizedDescription)"
            showError = true
        }
        
        isLoading = false
    }
}

// Helper view for displaying individual friends
struct FriendListRow: View {
    @EnvironmentObject var nav: NavigationHandler
    let friend: User
    
    var body: some View {
        Button(action: {
            nav.currentPage = .otherProfile(user: friend, source: .friendsList)
        }) {
            HStack {
                ProfilePhotoHelper.getProfileImageView(for: friend, size: .small)
                
                VStack(alignment: .leading) {
                    Text(friend.username)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text("\(friend.numberOfWins) wins")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                SwordPhotoTemplate(image: String(friend.sword))
                    .foregroundColor(.secondary)
                    .font(.caption)                
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    FriendsList_V()
}

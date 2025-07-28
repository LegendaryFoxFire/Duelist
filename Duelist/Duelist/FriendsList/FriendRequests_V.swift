//
//  FriendRequests_V.swift
//  Duelist
//
//  Created by Sam on 19/07/25.
//

import SwiftUI

struct FriendRequests_V: View {
    @EnvironmentObject var nav: NavigationHandler
    @EnvironmentObject var authManager: AuthManager
    
    @State private var friendRequests: [User] = []
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var processingRequests: Set<String> = []
    
    var body: some View {
        D_Background {
            BackButton(label: "Friends List", destination: .friendsList) {
                VStack {
                    D_Label(title: "Friend Requests", fontSize: Globals.LargeTitleFontSize)
                        .font(.largeTitle)
                    
                    if isLoading {
                        ProgressView("Loading requests...")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if friendRequests.isEmpty {
                        VStack {
                            Text("No friend requests")
                                .font(.title2)
                                .foregroundColor(.secondary)
                            Text("When someone sends you a friend request, it will appear here.")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        D_List {
                            ForEach(friendRequests, id: \.id) { friend in
                                D_ListRow {
                                    FriendRequestListRow(
                                        friend: friend,
                                        isProcessing: processingRequests.contains(friend.userID),
                                        onAccept: {
                                            await acceptFriendRequest(friend)
                                        },
                                        onReject: {
                                            await rejectFriendRequest(friend)
                                        }
                                    )
                                }
                            }
                        }
                    }
                }
            }
            .padding(.top, 10)
        }
        .task {
            await loadFriendRequests()
        }
        .alert("Error", isPresented: $showError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func loadFriendRequests() async {
        isLoading = true
        
        do {
            friendRequests = try await authManager.loadFriendRequests()
        } catch {
            errorMessage = "Failed to load friend requests: \(error.localizedDescription)"
            showError = true
        }
        
        isLoading = false
    }
    
    private func acceptFriendRequest(_ request: User) async {
        processingRequests.insert(request.userID)
        
        do {
            try await authManager.acceptFriendRequest(from: request.userID)
            
            // Remove from local list
            friendRequests.removeAll { $0.userID == request.userID }
        } catch {
            errorMessage = "Failed to accept friend request: \(error.localizedDescription)"
            showError = true
        }
        
        processingRequests.remove(request.userID)
    }
    
    private func rejectFriendRequest(_ request: User) async {
        processingRequests.insert(request.userID)
        
        do {
            try await authManager.rejectFriendRequest(from: request.userID)
            
            // Remove from local list
            friendRequests.removeAll { $0.userID == request.userID }
        } catch {
            errorMessage = "Failed to reject friend request: \(error.localizedDescription)"
            showError = true
        }
        
        processingRequests.remove(request.userID)
    }
}

// Updated FriendRequestListRow in FriendRequests_V.swift
struct FriendRequestListRow: View {
    @EnvironmentObject var nav: NavigationHandler
    let friend: User
    let isProcessing: Bool
    let onAccept: () async -> Void
    let onReject: () async -> Void
    
    var body: some View {
        HStack {
            Button(action: {
                nav.currentPage = .otherProfile(user: friend, source: .friendRequests)
            }) {
                HStack {
                    ProfilePhotoHelper.getProfileImageView(for: friend, size: .small)
                    D_Label(title: friend.username, fontSize: Globals.HeadingFontSize)
                }
            }
            .buttonStyle(.plain)
            
            Spacer()
            
            if isProcessing {
                ProgressView()
                    .scaleEffect(0.8)
            } else {
                HStack(spacing: 10) {
                    Button("Accept") {
                        Task {
                            await onAccept()
                        }
                    }
                    .foregroundColor(.green)
                    .padding(.horizontal, 8)
                    
                    Button("Reject") {
                        Task {
                            await onReject()
                        }
                    }
                    .foregroundColor(.red)
                    .padding(.horizontal, 8)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    FriendRequests_V()
}

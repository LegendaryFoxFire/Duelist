//
//  OtherProfile_V.swift
//  Duelist
//
//  Created by Sam on 19/07/25.
//

import SwiftUI

struct OtherProfile_V: View {
    @EnvironmentObject var nav: NavigationHandler
    @EnvironmentObject var authManager: AuthManager
    
    @State private var userRank: Int = 0
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    let user: User
    let sourceDestination: NavigationPage // Where to go back to
    
    var body: some View {
        D_Background {
            BackButton(label: getBackButtonLabel(), destination: sourceDestination) {
                VStack(spacing: Globals.ProfileVSpacing) {
                    
                    VStack {
                        D_Label(title: "Profile", fontSize: Globals.LargeTitleFontSize)
                        ProfilePhotoHelper.getProfileImageView(for: user, size: .large)
                        Image(String(user.sword))
                            .resizable()
                            .frame(width: 100, height: 100)
                            .shadow(color: .yellow.opacity(0.9), radius: 10, x: 0, y: 5)
                            .offset(x: 75, y: -120)
                    }
                    
                    if isLoading {
                        ProgressView("Loading rank...")
                            .frame(maxWidth: .infinity)
                    } else {
                        Grid(alignment: .leading, horizontalSpacing: Globals.StandardHSpacing, verticalSpacing: Globals.StandardVSpacing) {
                            GridRow {
                                D_Label(title: "Username: ", fontSize: Globals.SmallTitleFontSize)
                                    .font(.title)
                                    .bold()
                                D_Label(title: user.username, fontSize: Globals.SmallTitleFontSize)
                                    .font(.title)
                            }
                            GridRow {
                                D_Label(title: "Total Wins: ", fontSize: Globals.SmallTitleFontSize)
                                    .font(.title)
                                    .bold()
                                D_Label(title: String(user.numberOfWins), fontSize: Globals.SmallTitleFontSize)
                                    .font(.title)
                            }
                            GridRow {
                                D_Label(title: "Rank: ", fontSize: Globals.SmallTitleFontSize)
                                    .font(.title)
                                    .bold(true)
                                D_Label(title: userRank > 0 ? String(userRank) : "Loading...", fontSize: Globals.SmallTitleFontSize)
                                    .font(.title)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: Globals.CornerRadius)
                                .stroke(Color.black, lineWidth: 2)
                                .background(Color.black.opacity(0.15))
                        )
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                }
            }
        }
        .task {
            await loadUserRank()
        }
        .alert("Error", isPresented: $showError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func getBackButtonLabel() -> String {
        switch sourceDestination {
        case .friendsList:
            return "Friends List"
        case .friendRequests:
            return "Friend Requests"
        case .sendFriendRequests:
            return "Add Friends"
        case .leaderboard:
            return "Leaderboard"
        default:
            return "Back"
        }
    }
    private func loadUserRank() async {
        isLoading = true
        
        do {
            userRank = try await authManager.getUserRank(for: user.userID)
        } catch {
            errorMessage = "Failed to load user rank: \(error.localizedDescription)"
            showError = true
        }
        
        isLoading = false
    }
}

#Preview {
    OtherProfile_V(
        user: User(
            id: "preview-id",
            userID: "preview-uid",
            username: "BillyJoseph456",
            numberOfWins: 10,
            sword: "Default",
            profilePicture: 4,
            volumeOn: true,
            theme: "background_0",
            notificationsOn: true,
            friendsListIDs: [],
            friendRequestIDs: [],
            sentFriendRequestIDs: []
        ),
        sourceDestination: .friendsList
    )
}

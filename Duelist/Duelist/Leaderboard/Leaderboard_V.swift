//
//  Leaderboard_V.swift
//  Duelist
//
//  Created by Sam on 19/07/25.
//

import SwiftUI

struct Leaderboard_V: View {
    @EnvironmentObject var nav: NavigationHandler
    @EnvironmentObject var authManager: AuthManager
    
    @State private var searchText: String = ""
    @State private var allUsers: [User] = []
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    var sortedUsers: [User] {
        allUsers.sorted { $0.numberOfWins > $1.numberOfWins }
    }
    
    var filteredLeaderboard: [User] {
        if searchText.isEmpty {
            return sortedUsers
        } else {
            return sortedUsers.filter {
                $0.username.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    var body: some View {
        D_Background {
            BackButton(label: "Main Menu", destination: .mainMenu) {
                VStack {
                    D_Label(title: "Leaderboard", fontSize: Globals.LargeTitleFontSize)
                    
                    if isLoading {
                        ProgressView("Loading leaderboard...")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        D_List {
                            VStack {
                                // "'search' is built into a d_textfield of .search type's suggestion box"
                                D_TextField(text: $searchText, type: .search, keyword: "players")
                                
                                HStack {
                                    D_Label(title: "Rank", fontSize: Globals.HeadingFontSize)
                                        .font(.headline)
                                        .frame(width: 60)
                                    
                                    D_Label(title: "User", fontSize: Globals.HeadingFontSize)
                                        .padding(.leading, 10)
                                        .font(.headline)
                                    
                                    Spacer()
                                    
                                    D_Label(title: "Wins", fontSize: Globals.HeadingFontSize)
                                        .font(.headline)
                                }
                                .padding(.horizontal)
                                
                                ForEach(Array(filteredLeaderboard.enumerated()), id: \.element.id) { index, user in
                                    D_ListRow {
                                        Button {
                                            NavigationHandler.animatePageChange {
                                                nav.currentPage = .otherProfile(user: user, source: .leaderboard)
                                            }
                                        } label: {
                                            HStack {
                                                // Rank number
                                                D_Label(title: "\(getRankForUser(user, in: sortedUsers))", fontSize: Globals.HeadingFontSize)
                                                    .font(.headline)
                                                    .foregroundColor(.primary)
                                                    .frame(width: 30)
                                                
                                                ProfilePhotoHelper.getProfileImageView(for: user, size: .small)

                                                
                                                D_Label(title: user.username, fontSize: Globals.HeadingFontSize)
                                                    .foregroundColor(.black)
                                                
                                                Spacer()
                                                
                                                D_Label(title: String(user.numberOfWins), fontSize: Globals.HeadingFontSize)
                                                    .foregroundColor(.black)
                                            }
                                            .contentShape(Rectangle())
                                        }
                                        .buttonStyle(BorderlessButtonStyle())
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
            await loadLeaderboard()
        }
        .alert("Error", isPresented: $showError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func loadLeaderboard() async {
        isLoading = true
        do {
            allUsers = try await authManager.loadAllUsers()
        } catch {
            errorMessage = "Failed to load leaderboard: \(error.localizedDescription)"
            showError = true
        }
        isLoading = false
    }
    
    private func getRankForUser(_ user: User, in sortedList: [User]) -> Int {
        var currentRank = 1
        var lastWins: Int? = nil
        var rankMap: [String: Int] = [:]
        
        for sortedUser in sortedList {
            if sortedUser.numberOfWins != lastWins {
                currentRank = rankMap.count + 1
                lastWins = sortedUser.numberOfWins
            }
            rankMap[sortedUser.userID] = currentRank
        }
        
        return rankMap[user.userID] ?? 0
    }
}

#Preview {
    Leaderboard_V()
}

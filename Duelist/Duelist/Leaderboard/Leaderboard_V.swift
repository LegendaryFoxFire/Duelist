//
//  Leaderboard_V.swift
//  Duelist
//
//  Created by Sam on 19/07/25.
//

import SwiftUI

struct Leaderboard_V: View {
    @EnvironmentObject var nav: NavigationHandler
    @EnvironmentObject var globalUsersManager: GlobalUsersManager

    @State private var searchText: String = ""
    var filteredLeaderboard: [Friend] {
        if searchText.isEmpty {
            return globalUsersManager.globalUserList
        } else {
            return globalUsersManager.globalUserList.filter {
                $0.friendsUserID.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    var body: some View {
        BackButton(label:"Main Menu", destination: .mainMenu) {
            VStack{
                D_TextField(text: $searchText, type: .search, keyword: "friends")
                
                List {
                    HStack{
                        Text("User")
                            .padding(.leading, 50)
                            .font(.headline)
                        Spacer()
                        Text("Number of Wins")
                            .font(.headline)
                    }
                    ForEach(filteredLeaderboard) { friend in
                        Button {
                            NavigationHandler.animatePageChange {
                                nav.currentPage = .leaderboardProfile(friend: friend)
                            }
                            
                        } label: {
                            HStack {
                                ProfilePhotoTemplate(size: .small, image: friend.image)
                                Text(String(friend.friendsUserID))
                                Spacer()
                                Text(String(friend.numberOfWins))
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
    }
}

#Preview {
    Leaderboard_V()
}

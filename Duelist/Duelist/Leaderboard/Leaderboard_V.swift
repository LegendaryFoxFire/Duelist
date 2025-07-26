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
        D_Background {
            BackButton(label:"Main Menu", destination: .mainMenu) {
                VStack{

                    D_Label(title: "Leaderboard", fontSize: Globals.LargeTitleFontSize)
                    
                    D_List {
                        VStack {
                            D_TextField(text: $searchText, type: .search, keyword: "Leaderboard")
                            HStack{
                                D_Label(title: "User", fontSize: Globals.HeadingFontSize)
                                    .padding(.leading, 50)
                                    .font(.headline)
                                Spacer()
                                D_Label(title: "Number of Wins", fontSize: Globals.HeadingFontSize)
                                    .font(.headline)
                            }
                            ForEach(filteredLeaderboard) { friend in
                                D_ListRow{
                                    Button {
                                        NavigationHandler.animatePageChange {
                                            nav.currentPage = .leaderboardProfile(friend: friend)
                                        }
                                        
                                    } label: {
                                        HStack {
                                            ProfilePhotoTemplate(size: .small, image: friend.image)
                                            D_Label(title: friend.friendsUserID, fontSize: Globals.HeadingFontSize)
                                                .foregroundColor(.black)
                                            Spacer()
                                            D_Label(title: String(friend.numberOfWins), fontSize: Globals.HeadingFontSize)
                                                .foregroundColor(.black)
                                            
                                        }
                                        .contentShape(Rectangle())
                                    }
                                    .buttonStyle(BorderlessButtonStyle())
                                }
                            }
                        }
                    }
                }
            }
            .padding(.top, 50)
        }
    }
}

#Preview {
    Leaderboard_V()
}

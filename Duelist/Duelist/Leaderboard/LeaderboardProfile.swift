//
//  LeaderboardProfile.swift
//  Duelist
//
//  Created by Sam on 22/07/25.
//

import SwiftUI

struct LeaderboardProfile: View {
    @EnvironmentObject var nav: NavigationHandler
    @EnvironmentObject var globalUsersManager: GlobalUsersManager
    
    var rank: Int {
        return globalUsersManager.globalUserList.firstIndex(where: { $0.id == friend.id })! + 1
    }
    var friend: Friend
    var body: some View {
        BackButton(label:"Leaderboard", destination: .leaderboard) {
            VStack{
                
                VStack{
                    D_Label(title: "Profile", fontSize: Globals.LargeTitleFontSize)
                    ProfilePhotoTemplate(size: .large, image: friend.image)
                }
                
                Grid(alignment: .leading, horizontalSpacing: Globals.StandardHSpacing, verticalSpacing: Globals.StandardVSpacing) {
                    GridRow {
                        D_Label(title: "Username: ", fontSize: Globals.SmallTitleFontSize)
                            .font(.title)
                            .bold()
                        D_Label(title: friend.friendsUserID, fontSize: Globals.SmallTitleFontSize)
                            .font(.title)
                    }
                    GridRow {
                        D_Label(title: "Total Wins: ", fontSize: Globals.SmallTitleFontSize)
                            .font(.title)
                            .bold()
                        D_Label(title: String(friend.numberOfWins), fontSize: Globals.SmallTitleFontSize)
                            .font(.title)
                    }
                    GridRow {
                        D_Label(title: "Rank: ", fontSize: Globals.SmallTitleFontSize)
                            .font(.title)
                            .bold(true)
                        D_Label(title: String(rank), fontSize: Globals.SmallTitleFontSize)
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
                Spacer()
            }
        }
    }
}

#Preview {
    LeaderboardProfile(friend: user02)
}

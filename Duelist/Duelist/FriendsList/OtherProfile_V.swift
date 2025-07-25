//
//  OtherProfile_V.swift
//  Duelist
//
//  Created by Sam on 19/07/25.
//

import SwiftUI

struct OtherProfile_V: View {
    @EnvironmentObject var nav: NavigationHandler
    @EnvironmentObject var globalUsersManager: GlobalUsersManager
    
    var rank: Int {
        return globalUsersManager.globalUserList.firstIndex(where: { $0.id == friend.id })! + 1
    }
    var friend: Friend
    var body: some View {
        D_Background {
            BackButton(label:"Friends List", destination: .friendsList) {
                VStack{
                    VStack{
                        D_Label(title: "Friend's Profile", fontSize: Globals.LargeTitleFontSize)
                        ProfilePhotoTemplate(size: .large, image: friend.image)
                        Image(friend.sword)
                            .resizable()
                            .frame(width: 100, height: 100)
                            .shadow(color: .yellow.opacity(0.9), radius: 10, x: 0, y: 5) // Shadow behind visible parts
                            .offset(x: 75, y: -120)
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
}

#Preview {
    OtherProfile_V(friend: Friend(id: UUID(), image: "profile_photo_4", friendsUserID: "BillyJoseph456", numberOfWins: 10, sword: "sword_0", friendsList: [], friendRequests: []))
}

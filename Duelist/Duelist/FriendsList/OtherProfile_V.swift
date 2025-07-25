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
        BackButton(label:"Friends List", destination: .friendsList) {
            VStack(spacing: Globals.StandardHSpacing){
                
                VStack{
                    Text("Profile")
                        .font(.largeTitle)
                        .bold(true)
                    ProfilePhotoTemplate(size: .large, image: friend.image)
                }
                
                Grid(alignment: .leading, horizontalSpacing: Globals.StandardHSpacing, verticalSpacing: Globals.StandardVSpacing) {
                    GridRow {
                        D_Label(title: "Username: ")
                            .font(.title)
                            .bold()
                        D_Label(title: friend.friendsUserID)
                            .font(.title)
                    }
                    GridRow {
                        D_Label(title: "Total Wins: ")
                            .font(.title)
                            .bold()
                        D_Label(title: String(friend.numberOfWins))
                            .font(.title)
                    }
                    GridRow {
                        D_Label(title: "Rank: ")
                            .font(.title)
                            .bold(true)
                        D_Label(title: String(rank))
                            .font(.title)
                    }
                    GridRow {
                        D_Label(title: "User ID: ")
                            .font(.title)
                            .bold(true)
                        D_Label(title: friend.id.uuidString)
                            .font(.caption)
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
        }
    }
}

#Preview {
    OtherProfile_V(friend: Friend(id: UUID(), image: "profile_photo_4", friendsUserID: "BillyJoseph456", numberOfWins: 10, friendsList: [], friendRequests: []))
}

//
//  Profile_V.swift
//  Duelist
//
//  Created by Sam on 19/07/25.
//

import SwiftUI

struct Profile_V: View {
    @EnvironmentObject var nav: NavigationHandler
    var friend: Friend  //FIXME: Need to load user from database
    var body: some View {
        BackButton(label:"Main Menu", destination: .mainMenu) {
            VStack(spacing: Globals.StandardHSpacing){
                VStack{
                    Text("Profile")
                        .font(.largeTitle)
                        .bold(true)
                    ProfilePhotoTemplate(size: .large, image: friend.image)
                }
                
                VStack{
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
                            D_Label(title: String(friend.rank))
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
                    
                    Button("Settings") {
                        nav.currentPage = .settings(friend: friend)
                    }
                }
            }
        }
    }
}

#Preview {
    Profile_V(friend: user04)
}

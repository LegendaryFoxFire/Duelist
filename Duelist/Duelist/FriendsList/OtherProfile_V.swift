//
//  OtherProfile_V.swift
//  Duelist
//
//  Created by Sam on 19/07/25.
//

import SwiftUI

struct OtherProfile_V: View {
    @EnvironmentObject var nav: NavigationHandler
    let friend: Friend

    var body: some View {
        
        VStack(spacing: Globals.StandardHSpacing){
            
            VStack{
                Text("Profile")
                    .font(.largeTitle)
                    .bold(true)
                Image("profile_photo_4")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(style: StrokeStyle(lineWidth: 4)))
            }
            

            VStack{
                // FIXME: Need to load this stuff from database
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
                }
                .frame(maxWidth: .infinity)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: Globals.CornerRadius)
                        .stroke(Color.black, lineWidth: 2)
                        .background(Color.black.opacity(0.15))
                )
                .padding(.horizontal)
                
                //Not sure how we want to do the navigation now
                Button("View Friends") {
                    nav.currentPage = .friendsList
                }
                
                Button("Settings") {
                    nav.currentPage = .settings
                }
                
                Button("Main Menu") {
                    nav.currentPage = .mainMenu
                }
            }
        }
        
    }
}

#Preview {
    OtherProfile_V(friend: Friend(id: UUID(), image: "profile_photo_4", friendsUserID: "BillyJoseph456", numberOfWins: 10, rank: 129))
}

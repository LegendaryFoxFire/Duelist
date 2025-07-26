//
//  Profile_V.swift
//  Duelist
//
//  Created by Sam on 19/07/25.
//

import SwiftUI

struct Profile_V: View {
    @EnvironmentObject var nav: NavigationHandler
    @EnvironmentObject var userManager: CurrentUserManager
    @EnvironmentObject var globalUsersManager: GlobalUsersManager
    
    var rank: Int {
        return globalUsersManager.globalUserList.firstIndex(where: { $0.id == userManager.currentUser.id })! + 1
    }
    var body: some View {
        BackButton(label:"Main Menu", destination: .mainMenu) {
            VStack(spacing: Globals.ProfileVSpacing){
                VStack{
                    D_Label(title: "Profile", fontSize: Globals.LargeTitleFontSize)

                    ProfilePhotoTemplate(size: .large, image: userManager.currentUser.image)
                }

                VStack{
                    Grid(alignment: .leading, horizontalSpacing: Globals.StandardHSpacing, verticalSpacing: Globals.StandardVSpacing) {
                        GridRow {
                            D_Label(title: "Username: ", fontSize: Globals.SmallTitleFontSize)
                                .font(.title)
                                .bold()
                            D_Label(title: userManager.currentUser.friendsUserID, fontSize: Globals.SmallTitleFontSize)
                                .font(.title)
                        }
                        GridRow {
                            D_Label(title: "Total Wins: ", fontSize: Globals.SmallTitleFontSize)
                                .font(.title)
                                .bold()
                            D_Label(title: String(userManager.currentUser.numberOfWins), fontSize: Globals.SmallTitleFontSize)
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
                    
                    Button("Settings") {
                        nav.currentPage = .settings
                    }
                }
            }
            .padding(.top, Globals.ProfileVSpacing)
        }
    }
}

#Preview {
    Profile_V()
}

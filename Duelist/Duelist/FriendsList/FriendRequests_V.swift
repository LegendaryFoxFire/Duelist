//
//  FriendRequests_V.swift
//  Duelist
//
//  Created by Sam on 19/07/25.
//

//FIXME: FRIENDREQUESTS IS JUST A DUMMY LIST (STORED IN FRIENDSLIST_VM) THAT THE DATABASE WILL POPULATE FOR EACH USER'S FRIEND REQUESTS

import SwiftUI


struct FriendRequests_V: View {
    @EnvironmentObject var nav: NavigationHandler
    @EnvironmentObject var userManager: CurrentUserManager
    
    var body: some View {
        D_Background {
            BackButton(label:"Friends List", destination: .friendsList) {
                VStack{
                    D_Label(title: "Friend Requests", fontSize: Globals.LargeTitleFontSize)
                        .font(.largeTitle)
                    D_List {
                        ForEach(userManager.currentUser.friendRequests, id: \.id) { friend in
                            D_ListRow {
                                FriendRequestListRow(friend: friend,
                                                     onAccept: {
                                    if let index = userManager.currentUser.friendRequests.firstIndex(where: { $0.id == friend.id }) {
                                        let acceptedFriend = userManager.currentUser.friendRequests.remove(at: index)
                                        userManager.currentUser.friendsList.append(acceptedFriend)
                                    }
                                },
                                                     onReject: {
                                    if let index = userManager.currentUser.friendRequests.firstIndex(where: { $0.id == friend.id }) {
                                        userManager.currentUser.friendRequests.remove(at: index)
                                    }
                                })
                            }
                        }
                    }
                }
            }
            .padding(.top, 10)
        }
    }
}

#Preview {
    FriendRequests_V()
}

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
        BackButton(label:"Friends List", destination: .friendsList) {
            VStack{
                List {
                    Section(header: Text("Friend Requests")){
                        ForEach(userManager.currentUser.friendRequests, id: \.id) { friend in
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
    }
}

#Preview {
    FriendRequests_V()
}

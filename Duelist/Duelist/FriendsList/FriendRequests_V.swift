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
    @State private var friendRequestLocal = friendRequests
    

    
    var body: some View {
        BackButton(label:"Friends List", destination: .friendsList) {
            VStack{
                List {
                    Section(header: Text("Friend Requests")){
                        ForEach(friendRequestLocal, id: \.id) { friend in
                            FriendRequestListRow(friend: friend,
                                             onAccept: {
                                                 if let index = friendRequestLocal.firstIndex(where: { $0.id == friend.id }) {
                                                     let acceptedFriend = friendRequestLocal.remove(at: index)
                                                     friendList.append(acceptedFriend)
                                                     friendRequests.remove(at: index)
                                                 }
                                             },
                                             onReject: {
                                                 if let index = friendRequestLocal.firstIndex(where: { $0.id == friend.id }) {
                                                     friendRequestLocal.remove(at: index)
                                                     friendRequests.remove(at: index)
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

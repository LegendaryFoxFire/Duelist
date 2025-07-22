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
    @State private var searchText: String = ""
    @State private var friendRequestLocal = friendRequests
    @State private var sentRequests: [Friend] = []
    
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
                    Section(header: Text("Search Global Users")){
                        // Simulate a global users list filter (add search logic if needed)
                        ForEach(globalUsers, id: \.id) { friend in
                            //FIXME: need to filter out users that are already in friendsList
                            HStack {
                                Image(friend.image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(style: StrokeStyle(lineWidth: 2)))
                                Text(friend.friendsUserID)
                                Spacer()
                                Button(sentRequests.contains(where: { $0.id == friend.id }) ? "Requested" : "Add") {
                                    sentRequests.append(friend)
                                    print("Sent friend request to \(friend.friendsUserID)")
                                }
                                .disabled(sentRequests.contains(where: { $0.id == friend.id }))
                                .buttonStyle(BorderlessButtonStyle())
                            }
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

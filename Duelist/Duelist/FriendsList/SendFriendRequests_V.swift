//
//  SendFriendRequests_V.swift
//  Duelist
//
//  Created by Sam on 22/07/25.
//

import SwiftUI

struct SendFriendRequests_V: View {
    @State private var searchText: String = ""
    @State private var sentRequests: [Friend] = []
    
    var potentialNewFriends: [Friend] = filterFriends(listToBeFiltered: globalUsers, friendsToFilter: friendList)
    var filteredPotentialNewFriends: [Friend] {
        if searchText.isEmpty {
            return potentialNewFriends
        } else {
            return potentialNewFriends.filter {
                $0.friendsUserID.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    var body: some View {
        
        List{
            VStack{
                D_TextField(text: $searchText, type: .search, keyword: "Global Users")
                
                ForEach(filteredPotentialNewFriends, id: \.id) { friend in
                    HStack {
                        ProfilePhotoTemplate(size: .small, image: friend.image)
                        Text(friend.friendsUserID)
                        Spacer()
                        Button(sentRequests.contains(where: { $0.id == friend.id }) ? "Requested" : "Add") {
                            //FIXME: Going to have to do database stuff when a friend request is sent
                            sentRequests.append(friend)
                            print("Sent friend request to \(friend.friendsUserID)")
                        }
                        .disabled(sentRequests.contains(where: { $0.id == friend.id }))
                        .buttonStyle(BorderlessButtonStyle())
                        .padding()
                    }
                }
            }
        }
    }
}

#Preview {
    SendFriendRequests_V()
}

//
//  SendFriendRequests_V.swift
//  Duelist
//
//  Created by Sam on 22/07/25.
//

import SwiftUI

struct SendFriendRequests_V: View {
    @EnvironmentObject var userManager: CurrentUserManager
    @EnvironmentObject var globalUsersManager: GlobalUsersManager

    @State private var searchText: String = ""

    //Im defining "potential friend" as someone who is not your current friend, has not already sent you a request, someone who you have not already sent a friend request to, and not yourself
    var potentialNewFriends: [Friend] {
        let currentFriends = userManager.currentUser.friendsList
        let friendRequests = userManager.currentUser.friendRequests
        var sentRequests = userManager.currentUser.sentFriendRequests
        
        let firstFilteredFriends = filterFriends(listToBeFiltered: globalUsersManager.globalUserList, friendsToFilter: currentFriends)
        let secondFilteredFriends = filterFriends(listToBeFiltered: firstFilteredFriends, friendsToFilter: friendRequests)
        return filterFriends(listToBeFiltered: secondFilteredFriends, friendsToFilter: sentRequests + [userManager.currentUser])
    }
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
        BackButton(label:"Friends List", destination: .friendsList) {
            VStack{
                D_Label(title: "Add New Friends", fontSize: Globals.LargeTitleFontSize)

                D_List{
                    VStack{
                        D_TextField(text: $searchText, type: .search, keyword: "Global Users")
                        
                        ForEach(filteredPotentialNewFriends, id: \.id) { friend in
                            D_ListRow {
                                HStack {
                                    
                                    ProfilePhotoTemplate(size: .small, image: friend.image)
                                    D_Label(title: friend.friendsUserID, fontSize: Globals.HeadingFontSize)
                                    Spacer()
                                    Button("Add") {
                                        //FIXME: Going to have to do database stuff when a friend request is sent
                                        userManager.currentUser.sentFriendRequests.append(friend)
                                    }
                                    .buttonStyle(BorderlessButtonStyle())
                                    .padding()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SendFriendRequests_V()
}

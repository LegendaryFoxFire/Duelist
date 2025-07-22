//
//  FriendsList_V.swift
//  Duelist
//
//  Created by John Bukoski on 7/15/25.
//

//FIXME: FRIENDLIST IS JUST A DUMMY LIST (STORED IN FRIENDSLIST_VM) THAT THE DATABASE WILL POPULATE FOR EACH USER'S FRIEND

import SwiftUI


struct FriendsList_V: View {
    @EnvironmentObject var nav: NavigationHandler
    @State private var searchText: String = ""

    var filteredFriends: [Friend] {
        if searchText.isEmpty {
            return friendList
        } else {
            return friendList.filter {
                $0.friendsUserID.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    //FIXME: Can't decide if I like the search bar at the top like this, or connected to the list like in SendFriendRequests_V
    var body: some View {
        VStack{
            D_TextField(text: $searchText, type: .search, keyword: "friends")

            List {
                ForEach(filteredFriends) { friend in
                    Button {
                        print("Friend Selected: \(friend.friendsUserID)")
//                        NavigationHandler.animatePageChange {
//                            nav.currentPage = .otherProfile
//                            //FIXME: Replace with "other profile" and pass the friend selected
//                        }
                    } label: {
                        HStack {
                            ProfilePhotoTemplate(size: .small, image: friend.image)
                            Text(String(friend.friendsUserID))
                            Spacer()
                            }
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            
            HStack(spacing: Globals.LargeHSpacing){
                Button("View Friend Requests"){
                    NavigationHandler.animatePageChange {
                        nav.currentPage = .viewFriendRequests
                    }
                }
                Button("Send Friend Requests"){
                    NavigationHandler.animatePageChange {
                        nav.currentPage = .sendFriendRequests
                    }
                }
                
            }
            .padding(Globals.SmallHPadding)
            Button("Main Menu"){
                NavigationHandler.animatePageChange {
                    nav.currentPage = .mainMenu
                }
            }
        }
    }
}

#Preview {
    FriendsList_V()
}

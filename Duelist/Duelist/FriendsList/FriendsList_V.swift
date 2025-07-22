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
    
    
    var body: some View {
        VStack{
            TextField("Search friends...", text: $searchText)
                        .padding(.horizontal)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

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
                            Image(friend.image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(style: StrokeStyle(lineWidth: 2)))
                            Text(String(friend.friendsUserID))
                            Spacer()
                            }
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            
            HStack(spacing: Globals.LargeHSpacing){
                Button("Add Friend"){
                    NavigationHandler.animatePageChange {
                        nav.currentPage = .addFriends
                    }
                }
                Button("Main Menu"){
                    NavigationHandler.animatePageChange {
                        nav.currentPage = .mainMenu
                    }
                }
                
            }
            .padding(Globals.SmallHPadding)
        }
    }
}

#Preview {
    FriendsList_V()
}

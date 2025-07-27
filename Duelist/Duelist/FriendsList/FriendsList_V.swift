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
    @EnvironmentObject var userManager: CurrentUserManager

    @State private var searchText: String = ""

    var filteredFriends: [Friend] {
        if searchText.isEmpty {
            return userManager.currentUser.friendsList
        } else {
            return userManager.currentUser.friendsList.filter {
                $0.friendsUserID.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    var body: some View {
        D_Background {
        BackButton(label:"Main Menu", destination: .mainMenu)  {
            VStack{
                D_Label(title: "Friends", fontSize: Globals.LargeTitleFontSize)
                
                D_List {
                    VStack{
                        D_TextField(text: $searchText, type: .search, keyword: "Friends")
                        
                        ForEach(filteredFriends, id: \.id) { friend in
                            D_ListRow {
                                Button {
                                    NavigationHandler.animatePageChange {
                                        nav.currentPage = .otherProfile(friend: friend)
                                    }
                                } label: {
                                    HStack {
                                        ProfilePhotoTemplate(size: .small, image: friend.image)
                                        D_Label(title: friend.friendsUserID, fontSize: Globals.HeadingFontSize)
                                            .foregroundColor(.black)
                                        
                                        Spacer()
                                        SwordPhotoTemplate(image: friend.sword)
                                    }
                                    .contentShape(Rectangle())
                                }
                                .buttonStyle(BorderlessButtonStyle())
                                .padding()
                                
                            }
                        }
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
//                Button("Main Menu"){
//                    NavigationHandler.animatePageChange {
//                        nav.currentPage = .mainMenu
//                    }
                }
            }
        }
    }
}

#Preview {
    FriendsList_V()
}

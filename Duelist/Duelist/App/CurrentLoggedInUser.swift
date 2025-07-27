//
//  CurrentLoggedInUser.swift
//  Duelist
//
//  Created by Sam on 24/07/25.
//

import Foundation

final class CurrentUserManager: ObservableObject {
    static let shared = CurrentUserManager()

    @Published var currentUser: Friend = user00

    private init() {}
}

final class GlobalUsersManager: ObservableObject {
    static let shared = GlobalUsersManager()

    @Published var globalUserList: [Friend] = globalPlayers     //A bug with this method is if a user changes their username or profile photo, the global list will not reflect that.

    private init() {}
}


//until the database gets up and running "Friend()" is in FriendList_VM
var user00 = Friend(image: "profile_photo_10", friendsUserID: "Esteban0_0", numberOfWins: 100, sword: "sword_4_tp", friendsList: list1, friendRequests: list2)
var user01 = Friend(image: "profile_photo_1", friendsUserID: "Jims43", numberOfWins: 45, sword: "sword_0_tp", friendsList: [], friendRequests: [])
var user02 = Friend(image: "profile_photo_2", friendsUserID: "NateDaGr8", numberOfWins: 4, sword: "sword_0_tp", friendsList: [], friendRequests: [])
var user03 = Friend(image: "profile_photo_3", friendsUserID: "MScott43", numberOfWins: 16, sword: "sword_0_tp", friendsList: [], friendRequests: [])
var user04 = Friend(image: "profile_photo_4", friendsUserID: "Nathaniel2343", numberOfWins: 43, sword: "sword_0_tp",  friendsList: [], friendRequests: [])
var user05 = Friend(image: "profile_photo_5", friendsUserID: "Mathmagicianl2343", numberOfWins: 30, sword: "sword_0_tp",  friendsList: [], friendRequests: [])
var user06 = Friend(image: "profile_photo_6", friendsUserID: "HingleMcringleberry", numberOfWins: 18, sword: "sword_0_tp",  friendsList: [], friendRequests: [])
var user07 = Friend(image: "profile_photo_7", friendsUserID: "James34", numberOfWins: 50, sword: "sword_0_tp", friendsList: [], friendRequests: [])
var user08 = Friend(image: "profile_photo_8", friendsUserID: "Wilbo23", numberOfWins: 0, sword: "sword_0_tp", friendsList: [], friendRequests: [])
var user09 = Friend(image: "profile_photo_9", friendsUserID: "JonBonesJones420", numberOfWins: 20, sword: "sword_0_tp",  friendsList: [], friendRequests: [])
var user10 = Friend(image: "profile_photo_10", friendsUserID: "McNugget32", numberOfWins: 16, sword: "sword_0_tp", friendsList: [], friendRequests: [])



var list1 = [user01, user02]

var list2 = [user05, user06, user07, user08, user09, user10]

let globalPlayers = [user00, user01, user02, user03, user04, user05, user06, user07, user08, user09, user10].sorted { $0.numberOfWins > $1.numberOfWins }

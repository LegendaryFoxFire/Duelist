//
//  FriendsList_VM.swift
//  Duelist
//
//  Created by John Bukoski on 7/15/25.
//

//FIXME: THESE ARE JUST DUMMY LISTS THAT THE DATABASE WILL POPULATE FOR EACH USER

import Foundation

struct Friend: Identifiable {
//struct FastFoodItem {
    var id: UUID
    var image: String
    var friendsUserID: String
    var numberOfWins: Int
    var rank: Int
}

var friendList = [
    Friend(id: UUID(), image: "profile_photo_0", friendsUserID: "BillyJoe13", numberOfWins: 23, rank: 25),
    Friend(id: UUID(), image: "profile_photo_1", friendsUserID: "James", numberOfWins: 23, rank: 25),
    Friend(id: UUID(), image: "profile_photo_2", friendsUserID: "Felipe", numberOfWins: 23, rank: 25),
    Friend(id: UUID(), image: "profile_photo_3", friendsUserID: "Jonathan", numberOfWins: 23, rank: 25),
    Friend(id: UUID(), image: "profile_photo_4", friendsUserID: "Enrique", numberOfWins: 23, rank: 25),
    Friend(id: UUID(), image: "profile_photo_5", friendsUserID: "Ethan", numberOfWins: 23, rank: 25),
]

var friendRequests = [
    Friend(id: UUID(), image: "profile_photo_6", friendsUserID: "Nathaniel2343", numberOfWins: 43, rank: 10),
    Friend(id: UUID(), image: "profile_photo_7", friendsUserID: "Mathmagicianl2343", numberOfWins: 3, rank: 1003),
    Friend(id: UUID(), image: "profile_photo_8", friendsUserID: "Esteban0_0", numberOfWins: 12, rank: 102),
    Friend(id: UUID(), image: "profile_photo_3", friendsUserID: "James34", numberOfWins: 433, rank: 1),
    Friend(id: UUID(), image: "profile_photo_9", friendsUserID: "Nate", numberOfWins: 4, rank: 100),
    Friend(id: UUID(), image: "profile_photo_10", friendsUserID: "MScott43", numberOfWins: 16, rank: 160)
]


let globalUsers = [
    Friend(id: UUID(), image: "profile_photo_0", friendsUserID: "Esteban0_0", numberOfWins: 12, rank: 102),
    Friend(id: UUID(), image: "profile_photo_1", friendsUserID: "James34", numberOfWins: 433, rank: 1),
    Friend(id: UUID(), image: "profile_photo_2", friendsUserID: "Nate", numberOfWins: 4, rank: 100),
    Friend(id: UUID(), image: "profile_photo_3", friendsUserID: "MScott43", numberOfWins: 16, rank: 160),
    Friend(id: UUID(), image: "profile_photo_4", friendsUserID: "Nathaniel2343", numberOfWins: 43, rank: 10),
    Friend(id: UUID(), image: "profile_photo_5", friendsUserID: "Mathmagicianl2343", numberOfWins: 3, rank: 1003),
    Friend(id: UUID(), image: "profile_photo_6", friendsUserID: "Esteban0_0", numberOfWins: 12, rank: 102),
    Friend(id: UUID(), image: "profile_photo_7", friendsUserID: "James34", numberOfWins: 433, rank: 1),
    Friend(id: UUID(), image: "profile_photo_8", friendsUserID: "Nate", numberOfWins: 4, rank: 100),
    Friend(id: UUID(), image: "profile_photo_9", friendsUserID: "MScott43", numberOfWins: 16, rank: 160),
    Friend(id: UUID(), image: "profile_photo_10", friendsUserID: "MScott43", numberOfWins: 16, rank: 160)
]

//
//  FriendsList_VM.swift
//  Duelist
//
//  Created by John Bukoski on 7/15/25.
//

import Foundation

struct Friend: Identifiable {
//struct FastFoodItem {
    var id: UUID
    var image: String
    var friendsUserID: String
    var numberOfWins: Int
    var rank: Int
}

let friendList = [
    Friend(id: UUID(), image: "profile_photo_0", friendsUserID: "BillyJoe13", numberOfWins: 23, rank: 25),
    Friend(id: UUID(), image: "profile_photo_1", friendsUserID: "James", numberOfWins: 23, rank: 25),
    Friend(id: UUID(), image: "profile_photo_2", friendsUserID: "Felipe", numberOfWins: 23, rank: 25),
    Friend(id: UUID(), image: "profile_photo_3", friendsUserID: "Jonathan", numberOfWins: 23, rank: 25),
    Friend(id: UUID(), image: "profile_photo_4", friendsUserID: "Enrique", numberOfWins: 23, rank: 25),
    Friend(id: UUID(), image: "profile_photo_5", friendsUserID: "Ethan", numberOfWins: 23, rank: 25),
    Friend(id: UUID(), image: "profile_photo_0", friendsUserID: "BillyJoe13", numberOfWins: 23, rank: 25),
    Friend(id: UUID(), image: "profile_photo_1", friendsUserID: "James", numberOfWins: 23, rank: 25),
    Friend(id: UUID(), image: "profile_photo_2", friendsUserID: "Felipe", numberOfWins: 23, rank: 25),
    Friend(id: UUID(), image: "profile_photo_3", friendsUserID: "Jonathan", numberOfWins: 23, rank: 25),
    Friend(id: UUID(), image: "profile_photo_4", friendsUserID: "Enrique", numberOfWins: 23, rank: 25),
    Friend(id: UUID(), image: "profile_photo_5", friendsUserID: "Ethan", numberOfWins: 23, rank: 25),
    Friend(id: UUID(), image: "profile_photo_0", friendsUserID: "BillyJoe13", numberOfWins: 23, rank: 25),
    Friend(id: UUID(), image: "profile_photo_1", friendsUserID: "James", numberOfWins: 23, rank: 25),
    Friend(id: UUID(), image: "profile_photo_2", friendsUserID: "Felipe", numberOfWins: 23, rank: 25),
    Friend(id: UUID(), image: "profile_photo_3", friendsUserID: "Jonathan", numberOfWins: 23, rank: 25),
    Friend(id: UUID(), image: "profile_photo_4", friendsUserID: "Enrique", numberOfWins: 23, rank: 25),
    Friend(id: UUID(), image: "profile_photo_5", friendsUserID: "Ethan", numberOfWins: 23, rank: 25)
]

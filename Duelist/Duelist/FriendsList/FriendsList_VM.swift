//
//  FriendsList_VM.swift
//  Duelist
//
//  Created by John Bukoski on 7/15/25.
//

//FIXME: THESE ARE JUST DUMMY LISTS THAT THE DATABASE WILL POPULATE FOR EACH USER

import Foundation

struct Friend: Identifiable, Hashable { //Hashable so we can make it into a set
    var id: UUID
    var image: String
    var friendsUserID: String
    var numberOfWins: Int
    var rank: Int
}
var user00 = Friend(id: UUID(), image: "profile_photo_0", friendsUserID: "Esteban0_0", numberOfWins: 12, rank: 102)
var user01 = Friend(id: UUID(), image: "profile_photo_1", friendsUserID: "James34", numberOfWins: 433, rank: 1)
var user02 = Friend(id: UUID(), image: "profile_photo_2", friendsUserID: "Nate", numberOfWins: 4, rank: 100)
var user03 = Friend(id: UUID(), image: "profile_photo_3", friendsUserID: "MScott43", numberOfWins: 16, rank: 160)
var user04 = Friend(id: UUID(), image: "profile_photo_4", friendsUserID: "Nathaniel2343", numberOfWins: 43, rank: 10)
var user05 = Friend(id: UUID(), image: "profile_photo_5", friendsUserID: "Mathmagicianl2343", numberOfWins: 3, rank: 1003)
var user06 = Friend(id: UUID(), image: "profile_photo_6", friendsUserID: "Esteban0_0", numberOfWins: 12, rank: 102)
var user07 = Friend(id: UUID(), image: "profile_photo_7", friendsUserID: "James34", numberOfWins: 433, rank: 1)
var user08 = Friend(id: UUID(), image: "profile_photo_8", friendsUserID: "Nate", numberOfWins: 4, rank: 100)
var user09 = Friend(id: UUID(), image: "profile_photo_9", friendsUserID: "JonBonesJones420", numberOfWins: 16, rank: 160)
var user10 = Friend(id: UUID(), image: "profile_photo_10", friendsUserID: "McNugget32", numberOfWins: 16, rank: 160)



var friendList = [user00] //user01, user02, user03, user04]

var friendRequests = [user05, user06, user07, user08, user09, user10]

let globalUsers = [user00, user01, user02, user03, user04, user05, user06, user07, user08, user09, user10]

func filterFriends(listToBeFiltered: [Friend], friendsToFilter: [Friend]) -> [Friend]{
    let listToBeFilteredSet: Set<Friend> = Set(listToBeFiltered)
    let friendsToFilterSet: Set<Friend> = Set(friendsToFilter)
    let filteredList: [Friend] = Array(listToBeFilteredSet.subtracting(friendsToFilterSet))
    return filteredList
}

/*
 chatgpt came up with this to filter based solely on IDs for efficiency
 func filterFriends(listToBeFiltered: [Friend], friendsToFilter: [Friend]) -> [Friend] {
     let filterIDs = Set(friendsToFilter.map { $0.id })
     return listToBeFiltered.filter { !filterIDs.contains($0.id) }
 }
 */

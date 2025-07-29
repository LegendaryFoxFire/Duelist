//
//  FriendsList_VM.swift
//  Duelist
//
//  Created by John Bukoski on 7/15/25.
//

//FIXME: THESE ARE JUST DUMMY LISTS THAT THE DATABASE WILL POPULATE FOR EACH USER

import Foundation

struct Friend: Identifiable, Hashable { //Hashable so we can make it into a set
    var id = UUID()
    var image: String
    var friendsUserID: String
    var numberOfWins: Int
    var sword: String
    var friendsList: [Friend]
    var friendRequests: [Friend]
    var sentFriendRequests: [Friend] = []    //New accounts never have sent friend requests
}

func filterFriends(listToBeFiltered: [Friend], friendsToFilter: [Friend]) -> [Friend]{
    let listToBeFilteredSet: Set<Friend> = Set(listToBeFiltered)
    let friendsToFilterSet: Set<Friend> = Set(friendsToFilter)
    let filteredList: [Friend] = Array(listToBeFilteredSet.subtracting(friendsToFilterSet))
    return filteredList
}



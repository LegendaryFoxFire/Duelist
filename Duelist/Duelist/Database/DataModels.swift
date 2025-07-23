////
////  DataModels.swift
////  Duelist
////
////  Created by Sebastian on 7/23/25.
////
//
//import Foundation
//import FirebaseFirestore
//
//struct UserModel: Identifiable, Codable {
//    @DocumentID var id: String?
//    let username: String
//    let totalWins: Int
//    let pfpPath: String
//    let friendsList: [FriendSchema]
//    let outFriendRequests: [FriendSchema]
//    let inFriendRequests: [FriendSchema]
//    var uid: String { id ?? "" }
//}
//
//struct FriendModel: Identifiable, Codable {
//    @DocumentID var id: String?
//    let since: Date
//    let username: String
//    let pfpPath: String
//    
//    var friendUid: String { id ?? "" }
//}
//
//struct LeaderboardEntry: Identifiable, Codable {
//    @DocumentID var id: String?
//    let totalWins: Int
//    let username: String
//    let pfpPath: String
//    let rank: Int
//    
//    var uid: String { id ?? "" }
//}
//

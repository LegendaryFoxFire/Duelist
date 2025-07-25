//
//  FirebaseService.swift
//  Duelist
//
//  Created by Sebastian on 7/23/25.
//

import Foundation
import Firebase
import FirebaseStorage

class FirebaseService: ObservableObject {
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    @Published var users: [UserModel] = []
    @Published var friends: [FriendModel] = []
    @Published var leaderboard: [LeaderboardEntry] = []
    
    func fetchUsers() {
        db.collection("users").addSnapshotListener { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("Error fetching users: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            self.users = documents.compactMap { document in
                try? document.data(as: UserModel.self)
            }
        }
    }
    
    func fetchFriends(for userUid: String) {
        db.collection("users").document(userUid).collection("friends")
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("Error fetching friends: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                self.friends = documents.compactMap { document in
                    try? document.data(as: FriendModel.self)
                }
            }
    }
    
    func fetchLeaderboard() {
        db.collection("leaderboard")
            .order(by: "rank")
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("Error fetching leaderboard: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                self.leaderboard = documents.compactMap { document in
                    try? document.data(as: LeaderboardEntry.self)
                }
            }
    }
    
    func downloadProfileImage(path: String, completion: @escaping (UIImage?) -> Void) {
        let imageRef = storage.reference(withPath: path)
        
        imageRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }
    }
}

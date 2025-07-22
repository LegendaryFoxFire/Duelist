//
//  LeaderboardListRow.swift
//  Duelist
//
//  Created by Sam on 22/07/25.
//

import SwiftUI

struct LeaderboardListRow: View {
    var friend: Friend
    
    var body: some View {
        HStack {
            ProfilePhotoTemplate(size: .small, image: friend.image)
            Text(friend.friendsUserID)
            Spacer()
        }
    }
}

#Preview {
    LeaderboardListRow(friend: user07)
}

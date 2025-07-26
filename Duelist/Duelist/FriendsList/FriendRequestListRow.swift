//
//  FriendRequestListRow.swift
//  Duelist
//
//  Created by Sam on 21/07/25.
//

import SwiftUI

struct FriendRequestListRow: View {
    var friend: Friend
    var onAccept: () -> Void
    var onReject: () -> Void

    var body: some View {
        HStack {
            ProfilePhotoTemplate(size: .small, image: friend.image)
            D_Label(title: friend.friendsUserID, fontSize: Globals.SmallHeadingFontSize)
            Spacer()
            Button("Accept", action: onAccept)
                .buttonStyle(BorderlessButtonStyle())
            Button("Reject", action: onReject)
                .buttonStyle(BorderlessButtonStyle())
        }
        .padding()
    }
}

#Preview {
    FriendRequestListRow(friend: Friend(
        id: UUID(),
        image: "profile_photo_10",
        friendsUserID: "Jimbo34",
        numberOfWins: 10,
        sword: "sword_0",
        friendsList: [],
        friendRequests: []),
        onAccept: {
        print("friend accepted")
    }, onReject: {
        print("friend rejected")
    })
}

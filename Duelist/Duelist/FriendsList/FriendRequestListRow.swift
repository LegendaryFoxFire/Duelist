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
            Image(friend.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .overlay(Circle().stroke(style: StrokeStyle(lineWidth: 2)))
            Text(friend.friendsUserID)
            Spacer()
            Button("Accept", action: onAccept)
                .buttonStyle(BorderlessButtonStyle())
            Button("Reject", action: onReject)
                .buttonStyle(BorderlessButtonStyle())
        }
    }
}

#Preview {
    FriendRequestListRow(friend: Friend(id: UUID(), image: "profile_photo_10", friendsUserID: "Jimbo34", numberOfWins: 10, rank: 200),
        onAccept: {
        print("friend accepted")
    }, onReject: {
        print("friend rejected")
    })
}

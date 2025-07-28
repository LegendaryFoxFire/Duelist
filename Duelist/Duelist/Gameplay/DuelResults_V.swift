//
//  DuelResults_V.swift
//  Duelist
//
//  Created by Sam on 19/07/25.
//

import SwiftUI

struct DuelResults_V: View {
    var winnerName: String

    var body: some View {
        VStack(spacing: 30) {
            Text("🏆 Duel Over!")
                .font(.largeTitle)
                .bold()

            Text("\(winnerName) Wins!")
                .font(.title)
                .foregroundColor(.green)

            Image(winnerName == "You" ? "playerProfile" : "opponentProfile") // Replace with your asset names
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .clipShape(Circle())
                .shadow(radius: 10)

            Button("Play Again") {
                // handle reset (optional)
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        .padding()
    }
}


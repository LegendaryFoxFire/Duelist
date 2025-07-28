//
//  Gameplay_V.swift
//  Duelist
//
//  Created by John Bukoski on 7/15/25.
//

import SwiftUI

struct GameplayView: View {
    @ObservedObject var viewModel: GameplayVM
    @StateObject var motion: motion

    var body: some View {
        if let winner = viewModel.winner {
               DuelResults_V(winnerName: winner)
        } else {
            VStack(spacing: 24) {
                Text("You: \(viewModel.localHealth) HP")
                Text("Opponent: \(viewModel.opponentHealth) HP")
                
                Text("Opponent Action: \(viewModel.opponentAction.rawValue.capitalized)")
                Text("My Action: \(viewModel.myAction)")
            }
            .padding()
        }
    }
}



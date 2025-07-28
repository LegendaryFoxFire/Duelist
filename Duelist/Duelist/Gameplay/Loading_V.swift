//
//  Loading_V.swift
//  Duelist
//
//  Created by Noah Aguillon on 7/26/25.
//

import SwiftUI

struct Loading_V: View {
    @StateObject private var viewModel = LoadingGame_VM()
    @State private var showGame = false
    
    var gameplayContent: some View {
            let multiplayer = viewModel.multiplayer
            let gameVM = GameplayVM(multipeer: multiplayer)
            let motionVM = motion()
            motionVM.delegate = gameVM

            return GameplayView(
                viewModel: gameVM,
                motion: motionVM
            )
    }

    var body: some View {
        VStack(spacing: 24) {
            Text("Finding Opponent...")
                .font(.largeTitle)
                .padding(.top)

            ProgressView()
                .scaleEffect(1.5)

            Text("Waiting for a nearby device to join the game.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
        }
        .padding()
        .onReceive(viewModel.$isConnected) { connected in
            if connected {
                showGame = true
            }
        }
        .fullScreenCover(isPresented: $showGame) {
            gameplayContent
        }
    }
}



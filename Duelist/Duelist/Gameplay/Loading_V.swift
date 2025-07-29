//
//  Loading_V.swift
//  Duelist
//
//  Created by Noah Aguillon on 7/26/25.
//

import SwiftUI

struct Loading_V: View {
    @StateObject private var viewModel: LoadingGame_VM
    @EnvironmentObject var authManager: AuthManager
    @State private var showGame = false
    @State private var gameplayVM: GameplayVM? = nil
    @State private var motionVM: motion? = nil
    
    // Initialize with time-staggered assignment
    init() {
        _viewModel = StateObject(wrappedValue: LoadingGame_VM(userID: "temp_user_id"))
    }
    
    // Initialize with specific user
    init(userID: String) {
        _viewModel = StateObject(wrappedValue: LoadingGame_VM(userID: userID))
    }
    
    var body: some View {
        D_Background {
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
                
                // Show current role for debugging
//                if let role = viewModel.multiplayer.currentRole {
//                    Text("Role: \(role == .advertiser ? "Advertising" : "Browsing")")
//                        .font(.caption)
//                        .foregroundColor(.secondary)
//                        .padding(.top, 10)
//                }
            }
            .padding()
        }
        .onReceive(viewModel.$isConnected) { connected in
            if connected && gameplayVM == nil {
                createGameplayVM()
                showGame = true
            }
        }
        .fullScreenCover(isPresented: $showGame) {
            if let gameVM = gameplayVM, let motion = motionVM {
                GameplayView(
                    viewModel: gameVM,
                    motion: motion
                )
            } else {
                Text("Loading game...")
            }
        }
        .onAppear {
            if let userID = authManager.user?.userID {
                print("📱 User ID available: \(userID)")
            }
        }
    }
    
    private func createGameplayVM() {
        let multiplayer = viewModel.multiplayer
        let gameVM = GameplayVM(multipeer: multiplayer, currentUser: authManager.user?.username ?? "Player")
        let motion = motion()
        motion.delegate = gameVM
        
        self.gameplayVM = gameVM
        self.motionVM = motion
    }
}

//
//  DuelResults_VM.swift (Debug Version)
//  Duelist
//
//  Created by Sam on 19/07/25.
//

import Foundation
import Combine

class DuelResults_VM: ObservableObject {
    @Published var winnerName: String
    @Published var currentUser: User?
    @Published var currentUserWon: Bool
    @Published var shouldStartNewGame: Bool = false
    @Published var actionStats: ActionStats
    
    private let authManager: AuthManager
    private let multiplayer: Multiplayer
    private var cancellables = Set<AnyCancellable>()
    private var hasSetupListener = false 
    
    init(winnerName: String, currentUser: User?, authManager: AuthManager, multiplayer: Multiplayer, actionStats: ActionStats) {
        self.winnerName = winnerName
        self.currentUser = currentUser
        self.authManager = authManager
        self.multiplayer = multiplayer
        self.actionStats = actionStats
        self.currentUserWon = (winnerName == "You")
        
        setupRematchListener()
    }
    
    private func setupRematchListener() {
        guard !hasSetupListener else {
            return
        }
        
        hasSetupListener = true
        
        multiplayer.$receivedGameState
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                if let isReplayRequest = state.isReplayRequest, isReplayRequest == true {
                    print("🔄 REMATCH REQUEST detected in DuelResults!")
                    print("🔄 Current shouldStartNewGame state: \(self?.shouldStartNewGame ?? false)")
                    
                    if self?.shouldStartNewGame == false {
                        print("🔄 Setting shouldStartNewGame to true")
                        self?.shouldStartNewGame = true
                    } else {
                        print("🔄 shouldStartNewGame already true, ignoring")
                    }
                } else {
                    print("📨 Regular game state update, ignoring in results screen")
                }
            }
            .store(in: &cancellables)
    }
    
    func updateWinCount() {
        guard let user = currentUser, currentUserWon else {
            //print("User didn't win")
            return
        }
                
        Task {
            do {
                try await FirebaseService.shared.updateUserWins(user.userID, user.numberOfWins + 1)
                
                await MainActor.run {
                    authManager.user?.numberOfWins += 1
                }
            } catch {
                print("Error updating win count: \(error)")
            }
        }
    }
    
    func startReplay() {
        guard let user = currentUser else {
            print("Error: No current user found for replay")
            return
        }
        
        let replayState = GameState(
            action: .idle,
            health: 30,
            opponent: user.username,
            isReplayRequest: true
        )
        
        multiplayer.send(gameState: replayState)
    }
    
    func createNewGameplayVM() -> GameplayVM {
        guard let user = currentUser else {
            return GameplayVM(multipeer: multiplayer, currentUser: "Unknown")
        }
        return GameplayVM(multipeer: multiplayer, currentUser: user.username)
    }
    
    func resetRematchState() {
        shouldStartNewGame = false
    }
}

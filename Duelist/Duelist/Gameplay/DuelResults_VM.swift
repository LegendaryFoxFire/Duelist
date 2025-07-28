//
//  DuelResults_VM.swift
//  Duelist
//
//  Created by Noah Aguillon on 7/27/25.
//

import Foundation
import Combine

class DuelResults_VM: ObservableObject {
    @Published var winnerName: String
    @Published var winnerUser: User?
    @Published var loserUser: User?
    @Published var currentUserWon: Bool
    
    private let authManager: AuthManager
    
    init(winnerName: String, currentUser: User?, opponentUser: User?, authManager: AuthManager) {
        self.winnerName = winnerName
        self.authManager = authManager
        self.currentUserWon = (winnerName == "You")
        
        if currentUserWon {
            self.winnerUser = currentUser
            self.loserUser = opponentUser
        } else {
            self.winnerUser = opponentUser
            self.loserUser = currentUser
        }
    }
    
    func updateWinCount() {
        guard let winner = winnerUser else { return }
        
        Task {
            do {
                print(winner.userID, "wins:", winner.numberOfWins)
                try await FirebaseService.shared.updateUserWins(winner.userID, winner.numberOfWins + 1)
                print(winner.userID, "wins updated")
                if currentUserWon {
                    await MainActor.run {
                        authManager.user?.numberOfWins += 1
                    }
                }
            } catch {
                print("Error updating win count: \(error)")
            }
        }
    }
    
    // Method to reset for new game
    func resetForNewGame() -> GameplayVM? {
        // This would create a new GameplayVM instance for a rematch
        // You'll need to pass the appropriate Multiplayer instance
        return nil // Implement based on your game flow
    }
}

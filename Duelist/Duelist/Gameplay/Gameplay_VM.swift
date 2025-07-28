//
//  Gameplay_VM.swift
//  Duelist
//
//  Created by Noah Aguillon on 7/26/25.
//

import UIKit
import Combine

class GameplayVM: ObservableObject {
    private var lastEvaluatedPair: (Action, Action) = (.idle, .idle)
    @Published var localHealth = 30
    @Published var opponentHealth = 30
    @Published var opponentAction: Action = .idle {
        didSet {
            evaluateDamage() // Recalculate when opponent acts
        }
    }
    @Published var myAction: Action = .idle {
        didSet {
            evaluateDamage() // Recalculate when I act
        }
    }

    
    let multipeer: Multiplayer
    private var cancellables = Set<AnyCancellable>()

    init(multipeer: Multiplayer) {
        self.multipeer = multipeer

        multipeer.$receivedGameState
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.opponentAction = state.action
                self?.opponentHealth = state.health
            }
            .store(in: &cancellables)
    }

    func handleLocalAction(_ action: Action) {
        print("Local action: \(action), Opponent action: \(opponentAction)")
        myAction = action
        sendState(action: action)
    }
    
    func sendState(action: Action) {
        print("Sending state: \(action), health: \(localHealth)")
        let state = GameState(action: action, health: localHealth)
        multipeer.send(gameState: state)
    }
    
    private func evaluateDamage() {
        let currentPair = (myAction, opponentAction)
        guard currentPair != lastEvaluatedPair else { return } // Prevent re-evaluation
        lastEvaluatedPair = currentPair

        if opponentAction == .attack && myAction != .block {
            localHealth = max(localHealth - 10, 0)
        }

        if myAction == .attack && opponentAction != .block {
            opponentHealth = max(opponentHealth - 10, 0)
        }
    }
}



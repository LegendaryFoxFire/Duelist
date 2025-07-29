//
//  Gameplay_VM.swift (Debug Version)
//  Duelist
//
//  Created by Noah Aguillon on 7/26/25.
//

import UIKit
import Combine
import SwiftUI

class GameplayVM: ObservableObject {
    private var lastEvaluatedPair: (Action, Action) = (.idle, .idle)
    private var attackCount: Int = 0
    private var blockCount: Int = 0
    private var totalActions: Int = 0
    
    @Published var winner: String? = nil
    @Published var localHealth = 30
    @Published var opponentHealth = 30
    @Published var isBlocking = false
    @Published var swordAngle: Double = 0
    @Published var opponentUser: String? = nil
    @Published var currentUser: String
    @Published var shouldStartRematch = false
    @Published var opponentAction: Action = .idle {
        didSet {
            print("🎮 OpponentAction changed to: \(opponentAction)")
            evaluateDamage()
        }
    }
    @Published var myAction: Action = .idle {
        didSet {
            print("🎮 MyAction changed to: \(myAction)")
            isBlocking = (myAction == .block)
            evaluateDamage()
        }
    }

    let multipeer: Multiplayer
    private var cancellables = Set<AnyCancellable>()
    private var isProcessingRematch = false

    init(multipeer: Multiplayer, currentUser: String) {
        self.multipeer = multipeer
        self.currentUser = currentUser
        self.opponentUser = multipeer.session.connectedPeers.first?.displayName

        multipeer.$receivedGameState
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handleReceivedGameState(state)
            }
            .store(in: &cancellables)
    }
    
    private func handleReceivedGameState(_ state: GameState) {
        if let isReplayRequest = state.isReplayRequest, isReplayRequest == true {
            if !isProcessingRematch {
                isProcessingRematch = true
                shouldStartRematch = true
                resetGame()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                    self?.isProcessingRematch = false
                }
            } else {
                print("Ignoring duplicate")
            }
            return
        }
        
        opponentAction = state.action
        opponentHealth = state.health
        
        if opponentUser == nil {
            opponentUser = state.opponent
        }
    }
    
    func requestReplay() {
        guard let opponent = opponentUser else {
            print("Error: No opponent user found for replay request")
            return
        }
                
        let replayState = GameState(
            action: .idle,
            health: 30,
            opponent: currentUser,
            isReplayRequest: true
        )
        
        multipeer.send(gameState: replayState)
        resetGame()
    }
    
    private func trackAction(_ action: Action) {
        switch action {
        case .attack:
            attackCount += 1
            totalActions += 1
        case .block:
            blockCount += 1
            totalActions += 1
        case .idle:
            break
        }
    }
    
    func getPlayStyle() -> PlayStyle {
        guard totalActions > 0 else { return .balanced }
        
        let attackPercentage = Double(attackCount) / Double(totalActions)
        let blockPercentage = Double(blockCount) / Double(totalActions)
        
        if attackPercentage > 0.65 {
            return .aggressive
        } else if blockPercentage > 0.65 {
            return .defensive
        } else {
            return .balanced
        }
    }
    
    func getActionStats() -> ActionStats {
        return ActionStats(
            attackCount: attackCount,
            blockCount: blockCount,
            totalActions: totalActions,
            playStyle: getPlayStyle()
        )
    }
    
    func resetGame() {
        DispatchQueue.main.async { [weak self] in
            self?.localHealth = 30
            self?.opponentHealth = 30
            self?.myAction = .idle
            self?.opponentAction = .idle
            self?.winner = nil
            self?.isBlocking = false
            self?.swordAngle = 0
            self?.lastEvaluatedPair = (.idle, .idle)
            
            self?.attackCount = 0
            self?.blockCount = 0
            self?.totalActions = 0
        }
    }

    func handleLocalAction(_ action: Action) {
        trackAction(action)
        myAction = action
        sendState(action: action)
    }
    
    func updateSwordAngle(_ angle: Double) {
        DispatchQueue.main.async { [weak self] in
            self?.swordAngle = angle
        }
    }
    
    func sendState(action: Action) {
        let state = GameState(
            action: action,
            health: localHealth,
            opponent: currentUser,
            isReplayRequest: false 
        )
        multipeer.send(gameState: state)
    }
    
    private func evaluateDamage() {
        let currentPair = (myAction, opponentAction)
        guard currentPair != lastEvaluatedPair else {
            return
        }
        lastEvaluatedPair = currentPair


        if opponentAction == .attack && myAction != .block {
            localHealth = max(localHealth - 10, 0)
        }

        if myAction == .attack && opponentAction != .block {
            opponentHealth = max(opponentHealth - 10, 0)
        }
        
        if localHealth <= 0 {
            winner = "Opponent"
        } else if opponentHealth <= 0 {
            winner = "You"
        }
    }
}

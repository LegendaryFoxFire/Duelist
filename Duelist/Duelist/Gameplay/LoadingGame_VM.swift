//
//  Multiplayer.swift
//  Duelist
//
//  Created by Noah Aguillon on 7/26/25.
//

import Foundation
import Combine

class LoadingGame_VM: ObservableObject {
    @Published var isConnected = false
    let multiplayer: Multiplayer
    private var cancellables = Set<AnyCancellable>()
    
    init(userID: String) {
        self.multiplayer = Multiplayer(userID: userID, useTimeStagger: true)
        setupConnectionListener()
    }
    
    init(userID: String, useHashAssignment: Bool) {
        if useHashAssignment {
            let role = Multiplayer.assignRoleWithoutOpponent(userID: userID)
            self.multiplayer = Multiplayer(role: role)
        } else {
            self.multiplayer = Multiplayer(userID: userID, useTimeStagger: true)
        }
        
        setupConnectionListener()
    }
    
    init(role: Multiplayer.MultipeerRole) {
        self.multiplayer = Multiplayer(role: role)
        setupConnectionListener()
    }
    
    private func setupConnectionListener() {
        multiplayer.$isConnected
            .receive(on: DispatchQueue.main)
            .sink { [weak self] connected in
                self?.isConnected = connected
                if connected {
                    print("Connected")
                }
            }
            .store(in: &cancellables)
    }
}




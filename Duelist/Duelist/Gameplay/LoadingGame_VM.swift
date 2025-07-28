//
//  LoadingGame_V.swift
//  Duelist
//
//  Created by Noah Aguillon on 7/26/25.
//

import Foundation
import MultipeerConnectivity
import Combine

class LoadingGame_VM: ObservableObject {
    @Published var isConnected = false
    let multiplayer: Multiplayer

    init() {
        //let role = Multiplayer.assignRole(from: UIDevice.current.name)
        let role = Multiplayer.MultipeerRole.browser
        print("Device Name: \(UIDevice.current.name)")
        print("Role: \(role)")

        self.multiplayer = Multiplayer(role: role)
        

        multiplayer.$isConnected
            .receive(on: DispatchQueue.main)
            .assign(to: &$isConnected)
        print("Connected to peer")
        
    }
}



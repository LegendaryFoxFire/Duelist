//
//  Multiplayer.swift
//  Duelist
//
//  Created by Noah Aguillon on 7/26/25.
//

import UIKit


struct GameState: Codable {
    let action: Action
    let health: Int
    let opponent: String
}



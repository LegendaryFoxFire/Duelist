//
//  ActionStats.swift
//  Duelist
//
//  Created by Noah Aguillon on 7/28/25.
//

import Foundation

enum PlayStyle: String, CaseIterable {
    case aggressive = "Aggressive"
    case defensive = "Defensive"
    case balanced = "Balanced"
    
    var description: String {
        switch self {
        case .aggressive:
            return "Favored attacking over defending"
        case .defensive:
            return "Focused on blocking and defense"
        case .balanced:
            return "Balanced attack and defense strategy"
        }
    }
    
    var emoji: String {
        switch self {
        case .aggressive:
            return "⚔️"
        case .defensive:
            return "🛡️"
        case .balanced:
            return "⚖️"
        }
    }
}

struct ActionStats {
    let attackCount: Int
    let blockCount: Int
    let totalActions: Int
    let playStyle: PlayStyle
    
    var attackPercentage: Double {
        guard totalActions > 0 else { return 0 }
        return Double(attackCount) / Double(totalActions) * 100
    }
    
    var blockPercentage: Double {
        guard totalActions > 0 else { return 0 }
        return Double(blockCount) / Double(totalActions) * 100
    }
}

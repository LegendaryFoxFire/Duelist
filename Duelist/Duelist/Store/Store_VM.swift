//
//  Store_VM.swift
//  Duelist
//
//  Created by Sam on 23/07/25.
//

import SwiftUI

struct sword: Identifiable{
    var id = UUID()
    var name: String
    var numWins: String
}

let sword0 = sword(name: "sword_0", numWins: "100")
let sword1 = sword(name: "sword_1", numWins: "0")

let swordList = [sword0, sword1]

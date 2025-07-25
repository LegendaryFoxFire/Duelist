//
//  Store_VM.swift
//  Duelist
//
//  Created by Sam on 23/07/25.
//

import SwiftUI

struct Sword: Identifiable{
    var id = UUID()
    var name: String
    var numWins: Int

}

var sword0 = Sword(name: "sword_0", numWins: 0)
var sword1 = Sword(name: "sword_1", numWins: 10)
var sword2 = Sword(name: "sword_2", numWins: 50)
var sword3 = Sword(name: "sword_3", numWins: 100)
var sword4 = Sword(name: "sword_4", numWins: 500)

var swordList = [sword0, sword1, sword2, sword3, sword4]

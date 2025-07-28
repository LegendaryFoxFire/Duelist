//
//  basicMotion.swift
//  motiontest
//
//  Created by Noah Aguillon on 7/25/25.
//

import UIKit

struct DeviceMotionData {
    var yaw: Double
    var acceleration: Double
    var action: Action
}

enum Action: String, Codable {
    case attack = "Attack"
    case block = "Block"
    case idle = "Idle"
    
    var actionValue: String{
        self.rawValue
    }
}

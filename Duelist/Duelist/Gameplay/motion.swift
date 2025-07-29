//
//  Gameplay_VM.swift
//  Duelist
//
//  Created by John Bukoski on 7/15/25.
//

import Foundation
import CoreMotion
import Combine
import QuartzCore
import SwiftUI

class motion: ObservableObject {
    @EnvironmentObject var authManager: AuthManager

    //For motion managment
    private let motionManager = CMMotionManager()
    private var lastUpdateTime: CFTimeInterval = CACurrentMediaTime()
    private var lastAccelleration: Double = 0
    private var lastyaw: Double = 0
    
    //Action Managment
    private var previousAction: Action = .idle
    private var actualAction: [Action] = []
    
    //Updating yaw to be better
    private var yawHistory: [Double] = []
    private let maxYawHistory = 15
    
    //For sword rotations in the gameplay_view
    private var angleHistory: [Double] = []
    private let maxAngleHistory = 5
    private var baseAngle: Double = 0
    private var hasSetBaseAngle = false
    @Published var deviceMotionData = DeviceMotionData(yaw: 0, acceleration: 0, action: Action.idle)
    @Published var swordAngle: Angle = .zero
    
    //Letting GameplayVM handle health and game updates
    weak var delegate: GameplayVM?

    init() {
        startDeviceMotionUpdates()
    }
    
    func degrees(radians:Double) -> Double {
        return 180 / Double.pi * radians
    }

    func startDeviceMotionUpdates() {
        guard motionManager.isDeviceMotionAvailable else {
            print("Device Motion is not available")
            return
        }
        motionManager.deviceMotionUpdateInterval = 1.0/60.0
        motionManager.startDeviceMotionUpdates(to: OperationQueue.current!) {
            (deviceMotion,error) in
            if error == nil {
                self.handleDeviceMotionUpdate(deviceMotion: deviceMotion!)
            } else {
                print("Error occurred")
            }
        }
    }
    
    func handleDeviceMotionUpdate(deviceMotion: CMDeviceMotion) {
        
        let currentTime = CACurrentMediaTime()
        let deltaTime = currentTime - self.lastUpdateTime
        self.lastUpdateTime = currentTime

        let acc = deviceMotion.userAcceleration

        let accelerationMagnitude = sqrt(acc.x * acc.x + acc.y * acc.y + acc.z * acc.z)
        
        let jerk = abs(accelerationMagnitude - self.lastAccelleration) / max(deltaTime, 0.001)
        self.lastAccelleration = accelerationMagnitude
        
        let yaw = deviceMotion.attitude.yaw
        let yawDelta = abs(yaw - self.lastyaw)
        self.lastyaw = yaw
        
        //shake dog
        yawHistory.append(degrees(radians: yaw))
        if yawHistory.count > maxYawHistory {
            yawHistory.removeFirst()
        }
        
        let rawAngle = degrees(radians: yaw)
        let normalizedAngle = normalizeAngle(rawAngle)
        let smoothedAngle = smoothAngle(normalizedAngle)
        
        swordAngle = Angle(degrees: smoothedAngle)
        delegate?.updateSwordAngle(smoothedAngle)
        
        deviceMotionData.acceleration = accelerationMagnitude
        deviceMotionData.yaw = degrees(radians: yaw)
        
        let currentAction = classifyMotion(acceleration: accelerationMagnitude, jerk: jerk, yawDelta: yawDelta)
        actualAction.append(currentAction)
        
        if(actualAction.count == 3){
            let newAction = classifyAction(actualAction)
            deviceMotionData.action = newAction
            actualAction.removeAll()

            if newAction != previousAction {
                previousAction = newAction
                delegate?.handleLocalAction(newAction)
            }
        }
        

    }

    deinit {
        motionManager.stopDeviceMotionUpdates()
    }
    
    private func smoothAngle(_ newAngle: Double) -> Double {
        angleHistory.append(newAngle)
        if angleHistory.count > maxAngleHistory {
            angleHistory.removeFirst()
        }
        
        var weightedSum = 0.0
        var totalWeight = 0.0
        
        for (index, angle) in angleHistory.enumerated() {
            let weight = Double(index + 1)
            weightedSum += angle * weight
            totalWeight += weight
        }
        
        return weightedSum / totalWeight
    }
    
    private func normalizeAngle(_ angle: Double) -> Double {
        var normalized = angle
        
        if !hasSetBaseAngle {
            baseAngle = angle
            hasSetBaseAngle = true
            return 0
        }
        
        normalized = angle - baseAngle
        
        while normalized > 180 {
            normalized -= 360
        }
        while normalized < -180 {
            normalized += 360
        }
        
        return normalized
    }
    
    func classifyMotion(acceleration: Double, jerk: Double, yawDelta: Double) -> Action {
        if acceleration > 0.7 && jerk < 1.5 {
            return .attack
        }
        if isShakeMotion(yawHistory) && jerk > 2.0 {
            return .block
        }
        return .idle
    }
    
    func classifyAction(_ actions: [Action]) -> Action {
        var counts: [Action: Int] = [:]
        for action in actions {
            counts[action, default: 0] += 1
        }
        return counts.max(by: { $0.value < $1.value })!.key
    }
    
    func isShakeMotion(_ history: [Double]) -> Bool {
        guard history.count >= 6 else { return false }
        
        var changes = 0
        for i in 1..<history.count - 1 {
            let delta1 = history[i] - history[i - 1]
            let delta2 = history[i + 1] - history[i]
            if delta1 * delta2 < 0 { //Changes directions, pain
                changes += 1
            }
        }
        return changes >= 3
    }
}

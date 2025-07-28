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
    //For Motion updates
    private let motionManager = CMMotionManager()
    private var lastUpdateTime: CFTimeInterval = CACurrentMediaTime()
    private var lastAccelleration: Double = 0
    private var lastyaw: Double = 0
    
    //For sound purposes
    private var previousAction: Action = .idle
    private var lastAngle: Double = 0
    
    //prevent too many repeated actions
    private var actualAction: [Action] = []
    
    //For better shake detection
    private var yawHistory: [Double] = []
    private let maxYawHistory = 15
    
    //For connection to Gameplay VM
    weak var delegate: GameplayVM?
    
    


    //Communication
    @Published var deviceMotionData = DeviceMotionData(yaw: 0, acceleration: 0, action: Action.idle)
    @Published var swordAngle: Angle = .zero
    

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
        
        //Get time and Delta time
        let currentTime = CACurrentMediaTime()
        let deltaTime = currentTime - self.lastUpdateTime
        self.lastUpdateTime = currentTime

        //Acceleration and magnitude in G's
        let acc = deviceMotion.userAcceleration
//        let xAccel = acc.x
//        let yAccel = acc.y
//        let zAccel = acc.z
        let accelerationMagnitude = sqrt(acc.x * acc.x + acc.y * acc.y + acc.z * acc.z)
        
        let jerk = abs(accelerationMagnitude - self.lastAccelleration) / max(deltaTime, 0.001)
        self.lastAccelleration = accelerationMagnitude
        
        //let yaw = deviceMotion.attitude.yaw
        let yaw = deviceMotion.attitude.yaw
        let yawDelta = abs(yaw - self.lastyaw)
        self.lastyaw = yaw
        
        //shake dog
        yawHistory.append(degrees(radians: yaw))
        if yawHistory.count > maxYawHistory {
            yawHistory.removeFirst()
        }

        
        //For image
        swordAngle = Angle(degrees: degrees(radians: yaw))
        self.lastAngle = swordAngle.degrees
        deviceMotionData.acceleration = accelerationMagnitude
        deviceMotionData.yaw = degrees(radians: yaw)
        
        let currentAction = classifyMotion(acceleration: accelerationMagnitude, jerk: jerk, yawDelta: yawDelta)
        //print("xAccel: \(xAccel), yAccel: \(yAccel), zAccel: \(zAccel)")
        actualAction.append(currentAction)
        
        if(actualAction.count == 3){
            let newAction = classifyAction(actualAction)
            deviceMotionData.action = newAction
            actualAction.removeAll()

                // Only send if the action is not idle
            if newAction != previousAction {
                print("Delagating properly? : \(String(describing: delegate))")
                print("New Actino: \(newAction)")
                previousAction = newAction
                delegate?.handleLocalAction(newAction)
            }
        }
        
//        if(actualAction.count == 10){
//            deviceMotionData.action = classifyAction(actualAction)
//            actualAction.removeAll()
//        }
        
        //print("Action: \(currentAction), Jerk: \(jerk), Acceleration: \(accelerationMagnitude), Yaw: \(degrees(radians: yaw))")
        print("Action: \(currentAction)")
        
        switch currentAction {
        case .attack:
            SoundManager.shared.playSound(named: "Strikes 1", time: TimeInterval(0))
        case .block:
            SoundManager.shared.playSound(named: "Block 2", time: TimeInterval(0))
        default:
            break
        }
    }

    deinit {
        motionManager.stopDeviceMotionUpdates()
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
            if delta1 * delta2 < 0 { // direction changed
                changes += 1
            }
        }
        return changes >= 3
    }
}

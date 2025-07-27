//
//  SoundManager.swift
//  motiontest
//
//  Created by Noah Aguillon on 7/26/25.
//

import UIKit
import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    private var player: AVAudioPlayer?

    func playSound(named name: String, fileExtension: String = "mp3", time: TimeInterval) {
        guard let url = Bundle.main.url(forResource: name, withExtension: fileExtension) else {
            print("⚠️ Sound file not found: \(name)")
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play(atTime: time)
        } catch {
            print("⚠️ Failed to play sound: \(error.localizedDescription)")
        }
    }
}


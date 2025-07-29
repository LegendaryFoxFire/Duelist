//
//  SoundManager.swift
//  motiontest
//
//  Created by Noah Aguillon on 7/26/25.
//

import UIKit
import AVFoundation

class AudioManager {
    static let shared = AudioManager()
    private var player: AVAudioPlayer?
    
    var isPlaying: Bool {
        return player?.isPlaying ?? false
    }
    
    func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }

    func playLoopingMusic(named filename: String, onlyIfEnabled enabled: Bool = true) {
        guard enabled else { return }
        
        // Stop any existing music first to prevent overlapping
        stopMusic()

        guard let url = Bundle.main.url(forResource: filename, withExtension: "mp3") else {
            print("Audio file not found: \(filename)")
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = -1
            player?.volume = 0.5
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("Failed to play audio: \(error)")
        }
    }
    
    func playSound(named filename: String, onlyIfEnabled enabled: Bool = true) {
        guard enabled else { return }

        guard let url = Bundle.main.url(forResource: filename, withExtension: "mp3") else {
            print("Audio file not found: \(filename)")
            return
        }

        do {
            // Create a separate player for sound effects so they don't interfere with music
            let soundPlayer = try AVAudioPlayer(contentsOf: url)
            soundPlayer.prepareToPlay()
            soundPlayer.play()
        } catch {
            print("Failed to play audio: \(error)")
        }
    }

    func stopMusic() {
        player?.stop()
        player = nil
    }
}

//
//  AudioManager.swift
//  BatbergVersusDeSeaver
//
//  Created by DAVID SHOW on 5/16/26.
//

import AVFoundation
import Foundation

class AudioManager {
    // use this globally for both SwiftUI as well as SpriteKit
    static let shared = AudioManager()

    private var music: AVAudioPlayer?
    private var sfx: [AVAudioPlayer] = []

    var musicVolume: Float = 0.5 {
        // once musicVolume is initiallized, set the value from music.volume to musicVolume
        didSet { music?.volume = musicVolume }
    }
    
    var sfxVolume: Float = 1.0
    
    private init() {
        setUpAudioSession()
    }
    
    // MARK: - SET UP

    private func setUpAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(
                .playback,
                mode: .default,
                options: [.mixWithOthers]
            )
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Audio session error: \(error)")
        }
    }

    // MARK: - MUSIC

    func playMusic(named name: String, fadeIn: TimeInterval = 0.0) {
        
        guard let url = Bundle.main.url(forResource: name, withExtension: "wav")
            else {
                print("Music file \(name) not found")
                return
            }

        do {
            music = try AVAudioPlayer(contentsOf: url)
            music?.numberOfLoops = -1
            music?.volume = 0.0
            music?.play()
            music?.setVolume(musicVolume, fadeDuration: fadeIn)
        } catch {
            print("Could not play music: \(error)")
        }
    }

    private var stopWorkItem: DispatchWorkItem?
    
    func stopMusic() {
        music?.stop()
    }

    func pauseMusic() {
        music?.pause()
    }

    func resumeMusic() {
        music?.play()
    }

    // MARK: - SOUND EFFECTS

    func playSFX(named name: String, fadeIn: TimeInterval = 0.0) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "wav")
            else {
                print("SFX file \(name) not found")
                return
            }
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.setVolume(sfxVolume, fadeDuration: fadeIn)
            player.play()
            sfx.append(player)
            // Clean up finished players
            sfx = sfx.filter { $0.isPlaying }
        } catch {
            print("Could not play SFX: \(error)")
        }
    }
    
    func playLoopingSFX(named name: String, fadeIn: TimeInterval = 0.0) {
        
        guard let url = Bundle.main.url(forResource: name, withExtension: "wav")
            else {
                print("Music file \(name) not found")
                return
            }

        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = -1
            player.volume = 0.0
            player.play()
            player.setVolume(musicVolume, fadeDuration: fadeIn)
            sfx.append(player)
            // Clean up finished players
            sfx = sfx.filter { $0.isPlaying }
        } catch {
            print("Could not play music: \(error)")
        }
    }
    
    func stopAllSFX() {
        sfx.forEach { $0.stop() }
        sfx.removeAll()
    }
    
    // MARK: - EVERYTHING
    
    func pauseAll() {
        music?.pause()
        sfx.forEach { $0.pause() }
    }
    
    func resumeAll() {
        music?.play()
        sfx.forEach { $0.play() }
    }
    
    func stopAll() {
        stopMusic()
        sfx.forEach { $0.stop() }
        sfx.removeAll()
    }

}

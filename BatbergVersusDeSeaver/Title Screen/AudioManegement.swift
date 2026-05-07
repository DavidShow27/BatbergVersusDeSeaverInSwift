//
//  AudioManegement.swift
//  BatbergVersusDeSeaver
//
//  Created by DIEGO CHAVEZ on 5/6/26.
//

import AVFoundation
import Foundation

class AudioManegement {
    var audioPlayer: AVAudioPlayer?

    func playSound(sound: String, type: String) {
        if let path = Bundle.main.path(forResource: sound, ofType: type) {
            do {
                audioPlayer = try AVAudioPlayer(
                    contentsOf: URL(fileURLWithPath: path)
                )
                audioPlayer?.numberOfLoops = -1  // Loop infinitely
                audioPlayer?.play()
            } catch {
                print("Could not find and play the sound file.")
            }
        }
    }
}

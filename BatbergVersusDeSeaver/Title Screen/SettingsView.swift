//
//  StartGameView.swift
//  BatbergVersusDeSeaver
//
//  Created by DIEGO CHAVEZ on 4/21/26.
//

import SwiftUI
internal import AVFAudio

struct SettingsView: View {
    @State var volume: Double = 0.5
    @Binding var audio: AudioManegement
    var body: some View {
        VStack{
            Text("Adjust the Volume")
            Slider(value: $volume, in: 0...1) { _ in
                audio.audioPlayer?.volume = Float(volume)
            }
            Text("Volume: \(Int(volume * 100))%")
        }
    }
}

#Preview {
    SettingsView(audio: .constant(AudioManegement()))
}

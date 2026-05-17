//
//  StartGameView.swift
//  BatbergVersusDeSeaver
//
//  Created by DIEGO CHAVEZ on 4/21/26.
//

import SwiftUI

struct SettingsView: View {
    @State var volume: Double = 0.5
    var body: some View {
        VStack{
            Text("Adjust the Volume")
            Slider(value: $volume, in: 0...1) { _ in
                AudioManager.shared.musicVolume = Float(volume)
            }
            Text("Volume: \(Int(volume * 100))%")
        }
    }
}

#Preview {
    SettingsView()
}

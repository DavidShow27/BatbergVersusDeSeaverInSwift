//
//  StartGameView.swift
//  BatbergVersusDeSeaver
//
//  Created by DIEGO CHAVEZ on 4/21/26.
//

import SwiftUI

struct SettingsView: View {
    @State var volume1: Float = 0.5
    @State var volume2: Float = 0.5
    var body: some View {
        
        ZStack {
            Color.orange.ignoresSafeArea()
            VStack{
                
                Spacer()
                
                Text("Settings")
                    .font(.custom("MortalKombat-Regular", size: 50))
                
                RoundedRectangle(cornerRadius: 25)
                    .frame(height: 1)
                Spacer()
                
                Text("Adjust Music Volume")
                    .font(.custom("MortalKombat-Regular", size: 30))
                
                Slider(value: $volume1, in: 0...1) { _ in
                    AudioManager.shared.musicVolume = volume1
                }
                Text("Volume: \(Int(volume1 * 100))%")
                    .font(.title2)
                
                Spacer()
                
                Text("Adjust SFX Volume")
                    .font(.custom("MortalKombat-Regular", size: 30))
                
                Slider(value: $volume2, in: 0...1) { _ in
                    AudioManager.shared.sfxVolume = volume2
                    AudioManager.shared.playSFX(named: "Hit")
                }
                Text("Volume: \(Int(volume2 * 100))%")
                    .font(.title2)
            }
            
        }
    }
}

#Preview {
    SettingsView()
}

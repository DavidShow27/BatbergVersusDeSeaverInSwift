//
//  TitleView.swift
//  BatbergVersusDeSeaver
//
//  Created by DIEGO CHAVEZ on 4/21/26.
//

internal import AVFAudio
import SpriteKit
import SwiftUI

struct TitleView: View {
    @State var showGame = false
    @State var audio = AudioManegement()
    var body: some View {
        NavigationView {
            ZStack {
                Color.orange.ignoresSafeArea()

                VStack {
                    Text("Batberg VS De Seaver")
                        .font(.custom("MortalKombat-Regular", size: 30))

                    Button {
                        showGame = true
                        audio.audioPlayer?.stop()
                    } label: {
                        ZStack {
                            Rectangle()
                                .frame(width: 200, height: 50)
                                .foregroundColor(.black)

                            Text("START GAME")
                                .font(.custom("MortalKombat-Regular", size: 10))
                                .foregroundColor(.white)
                        }
                    }
                    NavigationLink(destination: SettingsView( audio: $audio)) {
                        ZStack {
                            Rectangle()
                                .frame(width: 200, height: 50)
                                .foregroundColor(.black)

                            Text("SETTINGS")
                                .font(.custom("MortalKombat-Regular", size: 10))
                                .foregroundColor(.white)
                        }
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showGame) {
            GameViewControllerRepresentable()
        }
        .onAppear {
            audio.playSound(sound: "!BvD", type: "wav")
        }

    }
    init() {
        for familyName in UIFont.familyNames {
            print(familyName)
            for fontName in UIFont.fontNames(forFamilyName: familyName) {
                print("--\(fontName)")
            }
        }
    }
}

#Preview {
    TitleView()
}

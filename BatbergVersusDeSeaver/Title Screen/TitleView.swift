//
//  TitleView.swift
//  BatbergVersusDeSeaver
//
//  Created by DIEGO CHAVEZ on 4/21/26.
//

import SpriteKit
import SwiftUI

struct TitleView: View {
    @State var showGame = false
    var body: some View {
        NavigationView {
            ZStack {
                Color.orange.ignoresSafeArea()

                VStack {
                    Text("Batberg VS De Seaver")
                        .font(.custom("MortalKombat-Regular", size: 30))

                    Button {
                        showGame = true
                        AudioManager.shared.stopMusic()
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
                    NavigationLink(destination: SettingsView()) {
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
                .ignoresSafeArea()
        }
        .onAppear {
            AudioManager.shared.playMusic(named: "!BvD")
        }

    }
}

#Preview {
    TitleView()
}

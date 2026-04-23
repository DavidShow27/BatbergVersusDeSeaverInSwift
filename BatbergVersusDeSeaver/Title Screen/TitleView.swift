//
//  TitleView.swift
//  BatbergVersusDeSeaver
//
//  Created by DIEGO CHAVEZ on 4/21/26.
//

import SwiftUI
import SpriteKit

struct TitleView: View {
    var scene: SKScene {
        let scene = GameScene()
        scene.size = CGSize(width: 300, height: 400)
        scene.scaleMode = .fill
        return scene
    }
    var body: some View {
        NavigationStack {
            ZStack {
                Color.orange.ignoresSafeArea()

                VStack {
                    Text("Batberg VS De Seaver")
                        .font(.custom("MortalKombat-Regular", size: 30))

                    NavigationLink(destination: GameView()) {
                        ZStack {
                            Rectangle()
                                .frame(width: 200, height: 50)
                                .foregroundColor(.black)

                            Text("START GAME")
                                .font(.custom("MortalKombat-Regular", size: 10))
                                .foregroundStyle(.white)
                        }
                    }
                }
            }
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

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
            
            Text("Batberg VS De Seaver")
                .font(.custom("MortalKombat-Regular", size: 30))
            SpriteView(scene: scene)
                .frame(width: 300, height: 400)
                .ignoresSafeArea()
            NavigationLink(destination: StartGameView()) {
                ZStack {
                    RoundedRectangle(cornerRadius: 100)
                        .stroke()
                        .frame(width: 200, height: 50)
                    Text("START GAME")
                }
            }
            .foregroundStyle(.black)
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

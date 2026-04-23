//
//  GameView.swift
//  BatbergVersusDeSeaver
//
//  Created by DIEGO CHAVEZ on 4/22/26.
//

import SwiftUI
import SpriteKit

struct GameView: View {
    var scene: SKScene {
        let scene = GameScene(size: CGSize(width: 800, height: 600))
        scene.scaleMode = .resizeFill
        return scene
    }
    var body: some View {
        SpriteView(scene: scene)
            .ignoresSafeArea()
            .navigationBarBackButtonHidden(true)
    }

}

#Preview {
    GameView()
}

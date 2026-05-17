//
//  GameView.swift
//  BatbergVersusDeSeaver
//
//  Created by DIEGO CHAVEZ on 4/22/26.
//

import SpriteKit
import SwiftUI

struct GameView: View {
    var scene: SKScene {
        let scene = GameScene(size: CGSize(width: 800, height: 600))
        scene.scaleMode = .resizeFill
        return scene
    }
    @State var showGame = true
    
    var body: some View {
        SpriteView(
            scene: {
                let scene = GameScene()

                scene.size = CGSize(width: 1000, height: 1000)

                
                scene.onExit = {
                    showGame = false
                    
                }

                return scene
            }()
        )
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
    }

}

#Preview {
    GameView()
}

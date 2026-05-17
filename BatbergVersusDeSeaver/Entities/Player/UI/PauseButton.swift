//
//  PauseButton.swift
//  BatbergVersusDeSeaver
//
//  Created by DIEGO CHAVEZ on 5/17/26.
//

import Foundation
import GameplayKit

class PauseButton: SKNode {

    var pause: SKShapeNode
    var pauseMenu: SKShapeNode?
    

    init(size: CGSize) {

        pause = SKShapeNode(circleOfRadius: 40)

        super.init()

        isUserInteractionEnabled = true

        pause.fillColor = .black
        pause.strokeColor = .white
        pause.lineWidth = 3
        pause.alpha = 0.8

        pause.position = CGPoint(
            x: size.width / 2 - 70,
            y: size.height / 2 - 70
        )

        pause.zPosition = 100
        pause.name = "pause"

        let leftBar = SKSpriteNode(
            color: .white,
            size: CGSize(width: 10, height: 35)
        )

        leftBar.position = CGPoint(x: -10, y: 0)

        let rightBar = SKSpriteNode(
            color: .white,
            size: CGSize(width: 10, height: 35)
        )

        rightBar.position = CGPoint(x: 10, y: 0)

        pause.addChild(leftBar)
        pause.addChild(rightBar)

        addChild(pause)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if scene?.physicsWorld.speed == 1 {

            scene?.physicsWorld.speed = 0

            AudioManager.shared.pauseAll()

            showPauseMenu()

        } else {

            scene?.physicsWorld.speed = 1

            AudioManager.shared.resumeAll()

            hidePauseMenu()
        }
        
        /*if scene!.isPaused{
            AudioManager.shared.pauseAll()
            showPauseMenu()
        }else{
            AudioManager.shared.resumeAll()
            hidePauseMenu()
        }*/
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        guard let touch = touches.first else { return }

        let location = touch.location(in: scene!)

        let tappedNodes = scene!.nodes(at: location)

        if tappedNodes.contains(where: {
            $0.name == "resetButton" ||
            $0.parent?.name == "resetButton"
        }) {

            if let gameScene = GameScene(fileNamed: "GameScene") {

                gameScene.scaleMode = .aspectFill

                scene?.view?.presentScene(
                    gameScene,
                    transition: SKTransition.fade(withDuration: 0.5)
                )
            }
        }
    }
    func showPauseMenu() {

        guard let scene = scene else { return }

        let overlay = SKShapeNode(
            rectOf: CGSize(width: scene.size.width * 2,
                           height: scene.size.height * 2)
        )
        overlay.isPaused = false
        

        overlay.fillColor = UIColor.black.withAlphaComponent(0.7)
        overlay.strokeColor = .clear

        overlay.position = CGPoint(x: scene.frame.midX,
                                   y: scene.frame.midY)

        overlay.zPosition = 200

        overlay.name = "pauseMenu"

        // RESET BUTTON
        let resetButton = SKShapeNode(
            rectOf: CGSize(width: 250, height: 80),
            cornerRadius: 20
        )
        resetButton.isPaused = false
        resetButton.fillColor = .black
        resetButton.strokeColor = .white
        resetButton.lineWidth = 4

        resetButton.position = CGPoint(x: 0, y: 0)

        resetButton.name = "resetButton"

        let label = SKLabelNode(text: "RESET")

        label.fontName = "MortalKombat-Regular"
        label.fontSize = 36
        label.fontColor = .white

        label.verticalAlignmentMode = .center

        resetButton.addChild(label)

        overlay.addChild(resetButton)

        //scene.addChild(overlay)
        scene.camera?.addChild(overlay)

        pauseMenu = overlay
    }
    func hidePauseMenu() {
        pauseMenu?.removeFromParent()
    }

}

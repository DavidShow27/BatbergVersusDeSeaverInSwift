//
//  GameViewController.swift
//  BatbergVersusDeSeaver
//
//  Created by DAVID SHOW on 4/16/26.
//

import GameplayKit
import SpriteKit
import UIKit

class GameViewController: UIViewController {

    var gameScene: GameScene!

    var player = Player.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") as? GameScene {
                gameScene = scene
                scene.scaleMode = .aspectFill
                view.presentScene(scene)
                
                view.ignoresSiblingOrder = true
                view.showsFPS = true
                view.showsNodeCount = true
            }
        }

        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var shouldAutorotate: Bool {
        return true
    }

    @IBAction func jumpAction(_ sender: Any) {
        // Check if player is Crouching
        if player.component(ofType: CrouchComponent.self)?.isCrouching == true {
            player.component(ofType: SlideComponent.self)?.slide()
        } else {
            player.component(ofType: JumpComponent.self)?.jump()
        }
    }

    @IBAction func abilityAction(_ sender: Any) {
        
    }
}

//
//  GameViewController.swift
//  BatbergVersusDeSeaver
//
//  Created by DAVID SHOW on 4/16/26.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var gameScene: GameScene!
    
    var player = Player()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
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
    
    @IBAction func jumpAction(_ sender: Any) {
        player.component(ofType: JumpComponent.self)?.jump()
    }
    
    @IBAction func abilityAction(_ sender: Any) {
    }
    
    @IBAction func leftAction(_ sender: Any) {
        player.component(ofType: MovementComponent.self)?.left()
    }
    
    @IBAction func rightAction(_ sender: Any) {
        player.component(ofType: MovementComponent.self)?.right()
    }
}


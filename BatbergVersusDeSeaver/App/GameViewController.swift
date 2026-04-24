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

    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") as? GameScene {
                gameScene = scene
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

        buttonStuff()
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
        player.component(ofType: JumpComponent.self)?.jump()
    }

    @IBAction func abilityAction(_ sender: Any) {
        
    }
    
    @objc func rightPressed() {
        player.component(ofType: MovementComponent.self)?.right()
    }

    @objc func rightReleased() {
        player.component(ofType: MovementComponent.self)?.stop()
    }
    
    @objc func leftPressed() {
        player.component(ofType: MovementComponent.self)?.left()
    }

    @objc func leftReleased() {
        player.component(ofType: MovementComponent.self)?.stop()
    }

    func buttonStuff() {
        rightButton.addTarget(
            self,
            action: #selector(rightPressed),
            for: .touchDown
        )
        rightButton.addTarget(
            self,
            action: #selector(rightReleased),
            for: .touchUpInside
        )
        rightButton.addTarget(
            self,
            action: #selector(rightReleased),
            for: .touchUpOutside
        )
        
        leftButton.addTarget(
            self,
            action: #selector(leftPressed),
            for: .touchDown
        )
        leftButton.addTarget(
            self,
            action: #selector(leftReleased),
            for: .touchUpInside
        )
        leftButton.addTarget(
            self,
            action: #selector(leftReleased),
            for: .touchUpOutside
        )
    }
    
}

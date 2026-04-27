//
//  GameScene.swift
//  BatbergVersusDeSeaver
//
//  Created by DAVID SHOW on 4/16/26.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var wallImage = ""
    var floorImage = ""
    
    var floor1 = SKSpriteNode()
    var wall1R = SKSpriteNode()
    var wall1L = SKSpriteNode()
    
    var player = Player.shared
    
    let cam = SKCameraNode()
    
    let joyStick = Joystick(size: 100)
    let actionButton = ActionButton(size: CGSize(width: 175, height: 175))
    
    //on scene load
    override func didMove(to view: SKView) {
        
        //addChild(makeFLoor(size: CGSize(width: 200, height: 20), position: CGPoint(x: 50, y: -50)))
        
        physicsWorld.contactDelegate = self
        
        wall1R = SKSpriteNode(imageNamed: wallImage)
        
        player.component(ofType: SpriteComponent.self)?.node
        = self.childNode(withName: "player") as! SKSpriteNode

        addChild(cam)
        self.camera = cam
        
        addChild(joyStick)
        addChild(actionButton)
        
        joyStick.onCrouchChanged = { isCrouching in
            if isCrouching {
                self.actionButton.label.text = "slide"
            } else {
                self.actionButton.label.text = "jump"
            }
        }
        
    }
    
    //before each frame
    override func update(_ currentTime: TimeInterval) {
        player.update(deltaTime: 1/60)
        
        guard let xPos = player.component(ofType: SpriteComponent.self)?.node.position.x else { return }
        guard let yPos = player.component(ofType: SpriteComponent.self)?.node.position.y else { return }
        
        cam.position.x = xPos
        cam.position.y = yPos + 100
        
        joyStick.position.x = xPos - (size.width / 3)
        joyStick.position.y = yPos - (size.height / 10)
        
        actionButton.position.x = xPos + (size.width / 3)
        actionButton.position.y = yPos - (size.height / 10)
        
    }
    
    // Contact
    func didBegin(_ contact: SKPhysicsContact) {
        player.component(ofType: JumpComponent.self)?.isJumping = false
        player.component(ofType: GroundPoundComponent.self)?.isGroundPounding = false
    }
    
    func makeFLoor(size: CGSize, position: CGPoint) -> SKSpriteNode{
        floor1 = SKSpriteNode(imageNamed: floorImage)
        floor1.size = size
        floor1.position = position
        floor1.physicsBody = SKPhysicsBody(rectangleOf: size)
        floor1.physicsBody?.affectedByGravity = false
        floor1.physicsBody?.pinned = true
        floor1.physicsBody?.collisionBitMask = 1
        floor1.name = "floor1"
        return floor1
    }
}


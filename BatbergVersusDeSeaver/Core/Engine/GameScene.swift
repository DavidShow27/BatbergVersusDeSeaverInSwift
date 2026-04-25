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
    
    //on scene load
    override func didMove(to view: SKView) {
        
        //addChild(makeFLoor(size: CGSize(width: 200, height: 20), position: CGPoint(x: 50, y: -50)))
        
        physicsWorld.contactDelegate = self
        
        wall1R = SKSpriteNode(imageNamed: wallImage)
        
        if let node = player.component(ofType: SpriteComponent.self)?.node {
            if node.parent == nil {
                node.position = (CGPoint(x: frame.midX, y: frame.midY))
                addChild(node)
            }
        }
        
        if cam.parent == nil {
            addChild(cam)
            self.camera = cam
        }
        
        joyStick.position = CGPoint(x: frame.midX - 500, y: frame.midY)
        addChild(joyStick)
        
    }
    
    //before each frame
    override func update(_ currentTime: TimeInterval) {
        player.update(deltaTime: 1/60)
        
        guard let xPos = player.component(ofType: SpriteComponent.self)?.node.position.x else { return }
        guard let yPos = player.component(ofType: SpriteComponent.self)?.node.position.y else { return }
        
        cam.position.x =  xPos
        cam.position.y = yPos
        
        joyStick.position.x = xPos - (size.width / 3)
        joyStick.position.y = yPos - (size.height / 4)
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


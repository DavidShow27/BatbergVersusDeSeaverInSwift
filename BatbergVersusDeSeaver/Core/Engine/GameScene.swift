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
    
    var player = Player()
    
    let cam = SKCameraNode()
    
    //on scene load
    override func didMove(to view: SKView) {
        
        addChild(makeFLoor(size: CGSize(width: 200, height: 20), position: CGPoint(x: 0, y: -20)))
        
        wall1R = SKSpriteNode(imageNamed: wallImage)
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
        //before each frame
    override func update(_ currentTime: TimeInterval) {
        cam.position.x = player.component(ofType: SpriteComponent.self)?.node.position.x ?? 0
        cam.position.y = player.component(ofType: SpriteComponent.self)?.node.position.y ?? 0
        
    }
    
    func jump() {
        player.component(ofType: SpriteComponent.self)?.node.physicsBody?.velocity.dy = 400
    }
    
    func moveLeft() {
        player.component(ofType: SpriteComponent.self)?.node.physicsBody?.velocity.dx = -300
    }
    
    func moveRight() {
        player.component(ofType: SpriteComponent.self)?.node.physicsBody?.velocity.dx = 300
    }
}


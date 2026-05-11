//
//  Bullet.swift
//  BatbergVersusDeSeaver
//
//  Created by DIEGO CHAVEZ on 5/5/26.
//

import Foundation
import GameplayKit

class Bullet: GKComponent {
    var bull: SKSpriteNode?
    let velocity = CGVector(dx: 600, dy: 0)

    override func didAddToEntity() {

        if let playerNode = entity?.component(ofType: SpriteComponent.self)?
            .node
        {
            bull = SKSpriteNode(imageNamed: "hook")
            bull?.position = playerNode.position
            bull?.setScale(0.1)
            bull?.zPosition = 0

            bull?.physicsBody = SKPhysicsBody(circleOfRadius: bull!.size.width / 2)
            
            bull?.physicsBody?.affectedByGravity = false
            bull?.physicsBody?.isDynamic = true
            
            bull?.physicsBody?.categoryBitMask = PhysicsCategory.bullet
            bull?.physicsBody?.contactTestBitMask =
            PhysicsCategory.floor | PhysicsCategory.enemy | PhysicsCategory.player
            bull?.physicsBody?.collisionBitMask =
            PhysicsCategory.floor | PhysicsCategory.enemy | PhysicsCategory.player
            bull?.physicsBody?.allowsRotation = false
            
            bull?.name = "bullet"
        }

    }
    func fire(in scene: SKScene){
        guard let bull = bull else { return }
        scene.addChild(bull)

        let move = SKAction.move(by: velocity, duration: 1)
        let repeatMove = SKAction.repeatForever(move)

        bull.run(repeatMove)
    }
}

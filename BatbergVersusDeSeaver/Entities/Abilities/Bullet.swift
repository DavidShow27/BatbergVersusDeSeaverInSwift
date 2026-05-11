//
//  Bullet.swift
//  BatbergVersusDeSeaver
//
//  Created by DIEGO CHAVEZ on 5/5/26.
//

import Foundation

class Bullet: GKComponent {
    var bull: SKSpriteNode?

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
}

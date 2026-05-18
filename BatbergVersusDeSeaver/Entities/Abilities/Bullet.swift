//
//  Bullet.swift
//  BatbergVersusDeSeaver
//
//  Created by DIEGO CHAVEZ on 5/5/26.
//

import Foundation
import GameplayKit

class BulletComponent: GKComponent {
    var bull: SKSpriteNode?
    var velocity = CGVector(dx: 2000, dy: 0)

    override func didAddToEntity() {

        if let playerNode = entity?.component(ofType: SpriteComponent.self)?
            .node
        {
            bull = SKSpriteNode(imageNamed: "bullet")
            bull?.position.x = playerNode.position.x + 500
            bull?.position.y = playerNode.position.y + 500
            bull?.setScale(0.1)
            bull?.zPosition = 0

            bull?.physicsBody = SKPhysicsBody(circleOfRadius: bull!.size.width / 2)
            
            bull?.physicsBody?.affectedByGravity = false
            bull?.physicsBody?.isDynamic = true
            
            bull?.physicsBody?.categoryBitMask = PhysicsCategory.bullet
            bull?.physicsBody?.contactTestBitMask =
            PhysicsCategory.floor | PhysicsCategory.enemy
            bull?.physicsBody?.collisionBitMask =
            PhysicsCategory.floor | PhysicsCategory.enemy
            bull?.physicsBody?.allowsRotation = false
            
            bull?.name = "bullet"
        }

    }
    func fire(){
        if let playerNode = entity?.component(ofType: SpriteComponent.self)?
            .node
        {
            bull = SKSpriteNode(imageNamed: "bullet")
            bull?.position.x = playerNode.position.x + 10
            bull?.position.y = playerNode.position.y + 5
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
            
            
            guard let scene = playerNode.parent else { return }
            
            scene.addChild(bull ?? SKSpriteNode(imageNamed: "bullet"))
            
            let dir = playerNode.xScale as CGFloat
            var count = 0
            if dir < 0 {
                velocity.dx = -abs(velocity.dx)
                bull?.position.x = playerNode.position.x - 10
                
            }else if dir > 0 && velocity.dx < 0{
                velocity.dx = abs(velocity.dx)
                bull?.position.x = playerNode.position.x + 10
                count += 1
            }
            
            let move = SKAction.move(by: velocity, duration: 0.5)
            let delete = SKAction.run { self.bull?.removeFromParent() }
            
            bull?.run(SKAction.sequence([move,delete]))
        }
    }
}

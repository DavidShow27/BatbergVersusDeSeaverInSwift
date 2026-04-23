//
//  StatComponents.swift
//  BatbergVersusDeSeaver
//
//  Created by DAVID SHOW on 4/22/26.
//

import Foundation
import GameplayKit

class SpriteComponent: GKComponent {
    var node: SKSpriteNode
    
    init(imageName: String) {
        node = SKSpriteNode(imageNamed: imageName)
        node.size = CGSize(width: 100, height: 100)
        super.init()

        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.allowsRotation = false
        node.physicsBody?.restitution = 0.0
        node.physicsBody?.friction = 0.5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class HealthComponent: GKComponent {
    
    var health: Int
    var maxHealth: Int
    
    init(health: Int) {
        self.health = health
        self.maxHealth = health
        super.init()
    }

    override func update(deltaTime seconds: TimeInterval) {
        if health <= 0 {
            die()
        }
    }

    func takeDamage(ammount: Int) {
        health -= ammount
    }

    func die() {
        print("You Died")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

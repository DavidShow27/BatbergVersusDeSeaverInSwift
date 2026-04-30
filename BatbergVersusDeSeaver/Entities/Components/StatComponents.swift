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
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PhysicsComponent: GKComponent {

    override func didAddToEntity() {
        guard let node = entity?.component(ofType: SpriteComponent.self)?.node
        else { return }
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.allowsRotation = false
        node.physicsBody?.restitution = 0.0
        node.physicsBody?.friction = 0.5

        assignCategories(to: node)

        node.physicsBody?.contactTestBitMask = 0xFFFF_FFFF  // report ALL contacts
        node.physicsBody?.collisionBitMask = 0xFFFF_FFFF  // collide with everything
    }
    
    func applyPhysics(to node: SKSpriteNode) {
        let currentVelocity = node.physicsBody?.velocity ?? .zero
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.allowsRotation = false
        node.physicsBody?.restitution = 0.0
        node.physicsBody?.friction = 0.5
        node.physicsBody?.velocity = currentVelocity
        assignCategories(to: node)

        node.physicsBody?.contactTestBitMask = 0xFFFF_FFFF  // report ALL contacts
        node.physicsBody?.collisionBitMask = 0xFFFF_FFFF  // collide with everything
    }

    private func assignCategories(to node: SKSpriteNode) {
        if entity is Player {
            node.physicsBody?.categoryBitMask = PhysicsCategory.player
            node.physicsBody?.contactTestBitMask = PhysicsCategory.enemy
            node.physicsBody?.collisionBitMask =
                PhysicsCategory.floor | PhysicsCategory.enemy
        } else if entity is Enemy {
            node.physicsBody?.categoryBitMask = PhysicsCategory.enemy
            node.physicsBody?.contactTestBitMask = PhysicsCategory.player
            node.physicsBody?.collisionBitMask =
                PhysicsCategory.floor | PhysicsCategory.player
        }
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
        guard let node = entity?.component(ofType: SpriteComponent.self)?.node
        else { return }

        if entity is Player {
            print("Player died — trigger game over")
            node.removeFromParent()
            // Post a notification to show Game Over UI from your scene
            NotificationCenter.default.post(name: .playerDied, object: nil)
        } else if entity is Enemy {
            print("Enemy died")
            node.removeFromParent()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Notification.Name {
    static let playerDied = Notification.Name("playerDied")
}

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
    
    var enemy = Enemy.shared
    
    let cam = SKCameraNode()
    
    let joyStick = Joystick(size: 100)
    let actionButton = ActionButton(size: CGSize(width: 175, height: 175))
    
    //on scene load
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        wall1R = SKSpriteNode(imageNamed: wallImage)
        
        if let playerNode = self.childNode(withName: "player") as? SKSpriteNode {
            player.component(ofType: SpriteComponent.self)?.node = playerNode
        }
        if let enemyNode = self.childNode(withName: "enemy") as? SKSpriteNode {
            enemy.component(ofType: SpriteComponent.self)?.node = enemyNode
        }

        addChild(cam)
        self.camera = cam
        
        joyStick.zPosition = 1
        actionButton.zPosition = 1
        addChild(joyStick)
        addChild(actionButton)
        
        joyStick.onCrouchChanged = { isCrouching in
            if isCrouching {
                self.actionButton.label.text = "slide"
            } else {
                self.actionButton.label.text = "jump"
            }
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleGameOver),
            name: .playerDied,
            object: nil
        )
        
    }
    
    @objc func handleGameOver() {
        // Pause the scene, show UI, etc.
        self.isPaused = true
        print("GAME OVER")
    }
    
    //before each frame
    override func update(_ currentTime: TimeInterval) {
        player.update(deltaTime: 1/60)
        enemy.update(deltaTime: 1/60)
        
        guard let xPos = player.component(ofType: SpriteComponent.self)?.node.position.x else { return }
        guard let yPos = player.component(ofType: SpriteComponent.self)?.node.position.y else { return }
        
        cam.position.x = xPos
        cam.position.y = yPos + 100
        
        joyStick.position.x = xPos - (size.width / 3)
        joyStick.position.y = yPos - (size.height / 10)
        
        actionButton.position.x = xPos + (size.width / 3)
        actionButton.position.y = yPos - (size.height / 10)
        
    }
    
    // Contact/Collision
    func didBegin(_ contact: SKPhysicsContact) {
        print("didBegin fired")
        print("bodyA: \(String(describing: contact.bodyA.node?.name))")
        print("bodyB: \(String(describing: contact.bodyB.node?.name))")

        guard
            let playerNode = player.component(ofType: SpriteComponent.self)?.node,
            let enemyNode  = enemy.component(ofType: SpriteComponent.self)?.node
        else {
            print("nodes are nil")
            return
        }

        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node

        guard (nodeA == playerNode && nodeB == enemyNode) ||
              (nodeA == enemyNode  && nodeB == playerNode) else {
            print("not a player/enemy contact, resetting jump")
            player.component(ofType: JumpComponent.self)?.isJumping = false
            player.component(ofType: GroundPoundComponent.self)?.isGroundPounding = false
            enemy.component(ofType: JumpComponent.self)?.isJumping = false
            enemy.component(ofType: GroundPoundComponent.self)?.isGroundPounding = false
            return
        }

        print("player/enemy contact detected!")

        let enemyTop = enemyNode.position.y + (enemyNode.size.height / 2)
        let contactY = contact.contactPoint.y
        let playerVelocity = contact.bodyA.node == playerNode ? contact.bodyA.velocity.dy : contact.bodyB.velocity.dy

        if contactY >= enemyTop - 20 && playerVelocity < 0 {
            print("STOMP")
            enemy.component(ofType: HealthComponent.self)?.takeDamage(ammount: 1)
            playerNode.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 300))
            player.component(ofType: JumpComponent.self)?.isJumping = true
        } else {
            print("SIDE HIT")
            player.component(ofType: HealthComponent.self)?.takeDamage(ammount: 1)
            let knockbackDir: CGFloat = playerNode.position.x > enemyNode.position.x ? 1 : -1
            playerNode.physicsBody?.applyImpulse(CGVector(dx: 300 * knockbackDir, dy: 200))
        }
    }
    
    func makeFLoor(size: CGSize, position: CGPoint) -> SKSpriteNode{
        /*floor1 = SKSpriteNode(imageNamed: floorImage)
        floor1.size = size
        floor1.position = position
        floor1.physicsBody = SKPhysicsBody(rectangleOf: size)
        floor1.physicsBody?.affectedByGravity = false
        floor1.physicsBody?.pinned = true
        floor1.physicsBody?.collisionBitMask = 1
        floor1.name = "floor1"
        return floor1*/
        floor1.physicsBody?.categoryBitMask    = PhysicsCategory.floor
        floor1.physicsBody?.collisionBitMask   = PhysicsCategory.player | PhysicsCategory.enemy
        floor1.physicsBody?.contactTestBitMask = PhysicsCategory.none
        return floor1
    }
}


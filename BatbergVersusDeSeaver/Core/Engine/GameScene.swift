//
//  GameScene.swift
//  BatbergVersusDeSeaver
//
//  Created by DAVID SHOW on 4/16/26.
//

import GameplayKit
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    var wallImage = ""
    var floorImage = ""

    var floor1 = SKSpriteNode()
    var wall1R = SKSpriteNode()
    var wall1L = SKSpriteNode()

    var player = Player.shared

    var enemy = Enemy.shared
    
    //var grapple: Grapple!
    var grappleSprite: SKSpriteNode!
    var selectedNode: SKSpriteNode?
    var touchStartPoint: CGPoint?

    let cam = SKCameraNode()

    let joyStick = Joystick(size: 100)
    let actionButton = ActionButton(size: CGSize(width: 175, height: 175))
    let grapple = Grapple(size: 200)
    
    //let topEdge = cam.position.y + (self.size.height / 2)
    /*
            let bottomEdge = self.frame.minY
            let leftEdge = self.frame.minX
            let rightEdge = self.frame.maxX*/

    //on scene load
    override func didMove(to view: SKView) {

        physicsWorld.contactDelegate = self

        wall1R = SKSpriteNode(imageNamed: wallImage)
        
        enumerateChildNodes(withName: "Floor") { node, _ in
            if let floor = node as? SKSpriteNode {
                floor.physicsBody = SKPhysicsBody(rectangleOf: floor.size)
                floor.physicsBody?.isDynamic = false
                
                floor.physicsBody?.categoryBitMask = PhysicsCategory.floor
                floor.physicsBody?.collisionBitMask =
                PhysicsCategory.player | PhysicsCategory.enemy | PhysicsCategory.grapple
                floor.physicsBody?.contactTestBitMask =
                PhysicsCategory.player | PhysicsCategory.enemy | PhysicsCategory.grapple

            }
        }
        
        if let playerNode = self.childNode(withName: "player") as? SKSpriteNode {
            player.component(ofType: SpriteComponent.self)?.node = playerNode
            
            playerNode.physicsBody?.categoryBitMask = PhysicsCategory.player
            playerNode.physicsBody?.collisionBitMask =
                PhysicsCategory.floor | PhysicsCategory.enemy
            playerNode.physicsBody?.contactTestBitMask =
                PhysicsCategory.enemy | PhysicsCategory.floor
        }
        
        if let enemyNode = self.childNode(withName: "enemy") as? SKSpriteNode {
            enemy.component(ofType: SpriteComponent.self)?.node = enemyNode
        }
        
        addChild(cam)
        self.camera = cam
        
        if let sprite = player.component(ofType: SpriteComponent.self)?.node {
            let position = sprite.position

            grappleSprite = SKSpriteNode(imageNamed: "grapple")
            grappleSprite.position = position
            grappleSprite.isHidden = true
            addChild(grappleSprite)

        }

        joyStick.zPosition = 1
        actionButton.zPosition = 1
        grapple.zPosition = 0
        
        addChild(joyStick)
        addChild(actionButton)
        addChild(grapple)

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
        player.update(deltaTime: 1 / 60)
        
        enemy.update(deltaTime: 1 / 60)

        guard let xPos = player.component(ofType: SpriteComponent.self)?.node.position.x else { return }
        guard let yPos = player.component(ofType: SpriteComponent.self)?.node.position.y else { return }

        cam.position.x = xPos
        cam.position.y = yPos + 100

        joyStick.position.x = xPos - (size.width / 3)
        joyStick.position.y = yPos - (size.height / 10)

        actionButton.position.x = xPos + (size.width / 3)
        actionButton.position.y = yPos - (size.height / 10)
        
        grapple.position = CGPoint(x: xPos, y: yPos)

    }

    // Contact/Collision
    func didBegin(_ contact: SKPhysicsContact) {

        // Clean way to check contacts without lots of if statements
        let bodyA = contact.bodyA.node?.name
        let bodyB = contact.bodyB.node?.name

        let names = [bodyA, bodyB]
        
        if names.contains("grapple") && names.contains("Floor") {
            if let grappleNode = player.component(ofType: GrappleComponent.self)?.grap {
                grappleNode.physicsBody?.velocity = .zero
                
            }
            player.component(ofType: GrappleComponent.self)?.canLaunchEntity = true
            player.component(ofType: GrappleComponent.self)?.grap?.removeFromParent()
        }
        
        if names.contains("grapple") && names.contains("player") {
            player.component(ofType: GrappleComponent.self)?.removeGrapple()
        }
        
        if names.contains("enemy") && names.contains("Floor") {
            enemy.component(ofType: JumpComponent.self)?.isJumping = false
            enemy.component(ofType: GroundPoundComponent.self)?
                .isGroundPounding = false
        }

        if names.contains("player") && names.contains("Floor") {
            player.component(ofType: JumpComponent.self)?.isJumping = false
            player.component(ofType: GroundPoundComponent.self)?
                .isGroundPounding = false
        }
        
        if names.contains("player") && names.contains("enemy") {
            
            let side = collisionSide(contactPoint: contact.contactPoint, node: contact.bodyA.node!)
            enemy.lastCollisionSide = side
            print(side)
        }

    }

}

// Checks collision Sides
enum CollisionSide {
    case top
    case bottom
    case left
    case right
    
    case reset
}

// returns the enum, not the component
func collisionSide(contactPoint: CGPoint, node: SKNode) -> CollisionSide {
    let dx = contactPoint.x - node.position.x
    let dy = contactPoint.y - node.position.y
    // check magnitudes of each value
    if abs(dx) > abs(dy) {
        // compare x side
        return dx > 0 ? .right : .left
    } else {
        // compare y side
        return dy > 0 ? .top : .bottom
    }

}

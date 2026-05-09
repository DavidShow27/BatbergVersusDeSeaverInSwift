//
//  GameScene.swift
//  BatbergVersusDeSeaver
//
//  Created by DAVID SHOW on 4/16/26.
//

import AVFoundation
import GameplayKit
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    var wallImage = ""
    var floorImage = ""

    var floor1 = SKSpriteNode()
    var wall1R = SKSpriteNode()
    var wall1L = SKSpriteNode()

    var player = Player.shared

    var enemies: [Enemy] = []

    //var grapple: Grapple!
    var grappleSprite: SKSpriteNode!
    var selectedNode: SKSpriteNode?
    var touchStartPoint: CGPoint?

    let cam = SKCameraNode()

    var spawnPoint: CGPoint = .zero

    let joyStick = Joystick(size: 100)
    let actionButton = ActionButton(size: CGSize(width: 175, height: 175))
    let grapple = Grapple(size: 200)

    var backgroundMusic: AVAudioPlayer?

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
                    PhysicsCategory.player | PhysicsCategory.enemy
                    | PhysicsCategory.grapple
                floor.physicsBody?.contactTestBitMask =
                    PhysicsCategory.player | PhysicsCategory.enemy
                    | PhysicsCategory.grapple

            }
        }

        if let playerNode = self.childNode(withName: "player") as? SKSpriteNode
        {
            player.component(ofType: SpriteComponent.self)?.node = playerNode
            spawnPoint = playerNode.position

            playerNode.physicsBody?.categoryBitMask = PhysicsCategory.player
            playerNode.physicsBody?.collisionBitMask =
                PhysicsCategory.floor | PhysicsCategory.enemy
            playerNode.physicsBody?.contactTestBitMask =
                PhysicsCategory.enemy | PhysicsCategory.floor

            player.component(ofType: HealthComponent.self)?.attachHealthBar(
                to: playerNode
            )

        }

        enumerateChildNodes(withName: "enemy*") { node, _ in
            let enemy = Enemy()
            if let spriteNode = enemy.component(ofType: SpriteComponent.self)?
                .node
            {
                spriteNode.position = node.position
                spriteNode.size.width = node.frame.width
                spriteNode.size.height = node.frame.height

                spriteNode.physicsBody?.categoryBitMask = PhysicsCategory.enemy
                spriteNode.physicsBody?.collisionBitMask =
                    PhysicsCategory.floor | PhysicsCategory.player
                spriteNode.physicsBody?.contactTestBitMask =
                    PhysicsCategory.player | PhysicsCategory.floor

                self.addChild(spriteNode)
                enemy.component(ofType: PhysicsComponent.self)?.applyPhysics(
                    to: spriteNode
                )
                enemy.component(ofType: HealthComponent.self)?.attachHealthBar(
                    to: spriteNode
                )
            }

            node.removeFromParent()
            self.enemies.append(enemy)
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
            selector: #selector(handlePlayerDied),
            name: .playerDied,
            object: nil
        )

        playBackgroundMusic()

    }

    func playBackgroundMusic() {
        guard
            let url =
                Bundle.main.url(
                    forResource: "background to the max",
                    withExtension: "wav"
                )
        else {
            print("Music file not found")
            return
        }

        do {
            backgroundMusic = try AVAudioPlayer(contentsOf: url)
            backgroundMusic?.numberOfLoops = -1  // loop forever
            backgroundMusic?.volume = 0.5
            backgroundMusic?.play()
        } catch {
            print("Could not load music: \(error)")
        }
    }

    @objc func handlePlayerDied() {
        guard
            let playerNode = player.component(ofType: SpriteComponent.self)?
                .node
        else { return }

        playerNode.physicsBody?.velocity = .zero
        playerNode.position = spawnPoint

        let health = player.component(ofType: HealthComponent.self)
        health?.health = health?.maxHealth ?? 3
        health?.isDead = false
        health?.healingTimer = 0  // resets the healing timer
        health?.updateHealthBar()
    }

    //before each frame
    override func update(_ currentTime: TimeInterval) {
        player.update(deltaTime: 1 / 60)

        for enemy in enemies {
            enemy.update(deltaTime: 1 / 60)
        }

        guard
            let xPos = player.component(ofType: SpriteComponent.self)?.node
                .position.x
        else { return }
        guard
            let yPos = player.component(ofType: SpriteComponent.self)?.node
                .position.y
        else { return }

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

        let involvedEnemy = enemies.first { enemy in
            let enemyNode = enemy.component(ofType: SpriteComponent.self)?.node
            return contact.bodyA.node === enemyNode
                || contact.bodyB.node === enemyNode
        }

        if names.contains("grapple") && names.contains("Floor") {
            if let grappleNode = player.component(
                ofType: GrappleComponent.self
            )?.grap {
                grappleNode.physicsBody?.velocity = .zero

            }
            player.component(ofType: GrappleComponent.self)?.canLaunchEntity =
                true
            player.component(ofType: GrappleComponent.self)?.grap?
                .removeFromParent()
        }

        if names.contains("grapple") && names.contains("player") {
            player.component(ofType: GrappleComponent.self)?.removeGrapple()
        }

        if names.contains("player") && names.contains("Floor") {
            player.component(ofType: JumpComponent.self)?.isJumping = false
            player.component(ofType: GroundPoundComponent.self)?
                .isGroundPounding = false
        }

        if let enemy = involvedEnemy, names.contains("Floor") {
            enemy.component(ofType: JumpComponent.self)?.isJumping = false
            enemy.component(ofType: GroundPoundComponent.self)?
                .isGroundPounding = false
        }

        if let enemy = involvedEnemy, names.contains("player") {

            guard
                let playerNode = player.component(ofType: SpriteComponent.self)?
                    .node
            else { return }
            guard
                let enemyNode = enemy.component(ofType: SpriteComponent.self)?
                    .node
            else { return }
            let side = collisionSide(nodeA: enemyNode, nodeB: playerNode)

            enemy.lastCollisionSide = side
            print("Collision side: \(side)")

            switch side {
            case .top:
                // Player landed on enemy's head
                enemy.component(ofType: HealthComponent.self)?.takeDamage(
                    ammount: 1
                )
                // Bounce player up
                playerNode.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 350))
                player.component(ofType: JumpComponent.self)?.isJumping = false

            case .bottom:
                // Enemy landed on player
                player.component(ofType: HealthComponent.self)?.takeDamage(
                    ammount: 1
                )
                let knockbackDir: CGFloat =
                    playerNode.position.x > enemyNode.position.x ? 1 : -1
                playerNode.physicsBody?.applyImpulse(
                    CGVector(dx: 250 * knockbackDir, dy: 150)
                )

            case .left, .right:
                // Side collision — player walks into enemy
                //player.component(ofType: HealthComponent.self)?.takeDamage(ammount: 1)
                let knockbackDir: CGFloat =
                    playerNode.position.x > enemyNode.position.x ? 1 : -1
                playerNode.physicsBody?.applyImpulse(
                    CGVector(dx: 250 * knockbackDir, dy: 150)
                )

            case .reset:
                break
            }

        }

        if names.contains("Fire") && names.contains("player") {
            guard
                let playerNode = player.component(ofType: SpriteComponent.self)?
                    .node

            else { return }
            player.component(ofType: HealthComponent.self)?.takeDamage(
                ammount: 1
            )
            playerNode.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 100.0))
        }

        if names.contains("tramp0") && names.contains("player") {
            guard
                let playerNode = player.component(ofType: SpriteComponent.self)?
                    .node

            else { return }

            playerNode.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 1500.0))
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
func collisionSide(nodeA: SKNode, nodeB: SKNode) -> CollisionSide {
    
    let dx = nodeB.position.x - nodeA.position.x
    let dy = nodeB.position.y - nodeA.position.y

    // essentially create a collisionX and collisionY
    let halfWidths = (nodeA.frame.width + nodeB.frame.width) / 2
    let halfHeights = (nodeA.frame.height + nodeB.frame.height) / 2

    // How much overlap on each axis
    let overlapX = halfWidths - abs(dx)
    let overlapY = halfHeights - abs(dy)

    let threshold: CGFloat = 10

    // Corner check
    if abs(overlapX - overlapY) < threshold {
        return .reset
    }

    // Whichever axis has less overlap is the side that was hit
    if overlapX < overlapY {
        return dx > 0 ? .right : .left
    } else {
        return dy > 0 ? .top : .bottom
    }

}

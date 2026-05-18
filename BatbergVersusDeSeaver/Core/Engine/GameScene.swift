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
    
    var onExit: (() -> Void)?

    var background = SKSpriteNode()

    var floor1 = SKSpriteNode()
    var wall1R = SKSpriteNode()
    var wall1L = SKSpriteNode()

    var player = Player.shared

    var enemies: [DeSeaver] = []
    var goattone: [Goattone] = []

    //var grapple: Grapple!
    var grappleSprite: SKSpriteNode!
    var selectedNode: SKSpriteNode?
    var touchStartPoint: CGPoint?

    let cam = SKCameraNode()

    var spawnPoint: CGPoint = .zero

    let joyStick = Joystick(size: 175)
    let actionButton = ActionButton(size: CGSize(width: 325, height: 325))
    let bulletButton = BulletButton(size: CGSize(width: 325, height: 325))
    let grapple = Grapple(size: 200)
    let abilityMeter = AbilityCoolDown(size: CGSize(width: 600, height: 20))
    let pause = PauseButton(size: CGSize(width: 200, height: 200))
    

    //let topEdge = cam.position.y + (self.size.height / 2)
    /*
            let bottomEdge = self.frame.minY
            let leftEdge = self.frame.minX
            let rightEdge = self.frame.maxX*/

    //on scene load
    override func didMove(to view: SKView) {

        physicsWorld.contactDelegate = self

        wall1R = SKSpriteNode(imageNamed: wallImage)

        background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.zPosition = -1
        addChild(background)

        enumerateChildNodes(withName: "Collision") { node, _ in
            guard let sprite = node as? SKSpriteNode else { return }
            sprite.alpha = 0
            sprite.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
            sprite.physicsBody?.isDynamic = false
            sprite.physicsBody?.friction = 0.5
            sprite.physicsBody?.restitution = 0.0
            sprite.physicsBody?.categoryBitMask = PhysicsCategory.floor
            sprite.physicsBody?.collisionBitMask =
                PhysicsCategory.player | PhysicsCategory.enemy
                | PhysicsCategory.grapple
            sprite.physicsBody?.contactTestBitMask =
                PhysicsCategory.player | PhysicsCategory.enemy
                | PhysicsCategory.grapple
            sprite.name = "Floor"
        }
        
        if let sprite = self.childNode(withName: "Boss Area") as? SKSpriteNode {
            sprite.alpha = 0
            sprite.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
            sprite.physicsBody?.isDynamic = false
            sprite.physicsBody?.categoryBitMask = PhysicsCategory.none
            sprite.physicsBody?.contactTestBitMask = PhysicsCategory.player
            sprite.name = "Boss Area"
        }

        if let playerNode = self.childNode(withName: "player") as? SKSpriteNode
        {
            player.component(ofType: SpriteComponent.self)?.node = playerNode
            player.component(ofType: HealthComponent.self)?.attachHealthBar(
                to: playerNode
            )
            spawnPoint = playerNode.position
        }

        enumerateChildNodes(withName: "boss*") { bossNode, _ in
            guard let newNode = self.makeGoattone(bossNode) else { return }
            newNode.position = bossNode.position
            self.addChild(newNode)
            bossNode.removeFromParent()
        }

        enumerateChildNodes(withName: "enemy*") { sksNode, _ in
            guard let newNode = self.makeEnemy(sksNode) else { return }
            newNode.position = sksNode.position
            self.addChild(newNode)
            sksNode.removeFromParent()
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
        bulletButton.zPosition = 1
        pause.zPosition = 10000
        grapple.zPosition = 0
        abilityMeter.zPosition = 1
        
        //var pauseMenu = pause.pauseMenu!

        addChild(joyStick)
        addChild(actionButton)
        addChild(bulletButton)
        addChild(grapple)
        addChild(abilityMeter)
        addChild(pause)
        //addChild(pauseMenu)

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
        
        AudioManager.shared.playMusic(named: "background to the max")

    }

    func makeEnemy(_ sksNode: SKNode) -> SKNode? {
        let enemy = DeSeaver()
        guard
            let spriteNode = enemy.component(ofType: SpriteComponent.self)?.node
        else { return nil }

        spriteNode.size.width = sksNode.frame.width
        spriteNode.size.height = sksNode.frame.height

        enemy.component(ofType: PhysicsComponent.self)?.applyPhysics(
            to: spriteNode
        )
        enemy.component(ofType: HealthComponent.self)?.attachHealthBar(
            to: spriteNode
        )

        enemies.append(enemy)

        return spriteNode
    }
    
    func makeGoattone(_ sksNode: SKNode) -> SKNode? {
        let boss = Goattone()
        guard
            let spriteNode = boss.component(ofType: SpriteComponent.self)?.node
        else { return nil }

        spriteNode.size.width = sksNode.frame.width
        spriteNode.size.height = sksNode.frame.height

        boss.component(ofType: PhysicsComponent.self)?.applyPhysics(
            to: spriteNode
        )
        boss.component(ofType: HealthComponent.self)?.attachHealthBar(
            to: spriteNode
        )

        goattone.append(boss)

        return spriteNode
    }

    @objc func handlePlayerDied() {
        
        // Stop user interaction
        joyStick.canMove = false
        joyStick.knob.position = joyStick.edge.position
        player.component(ofType: MovementComponent.self)?.velocity = .zero

        // Stop external nodes from interacting with player
        guard
            let playerNode = player.component(ofType: SpriteComponent.self)?
                .node
        else { return }
        playerNode.physicsBody?.velocity = .zero
        playerNode.physicsBody?.isDynamic = false
        playerNode.isHidden = true

        // Overlay needs to be sized to the camera/screen, not the scene
        let screenSize = CGSize(
            width: self.size.width * 2,
            height: self.size.height * 2
        )
        let overlay = SKShapeNode(rectOf: screenSize)
        overlay.fillColor = UIColor.black.withAlphaComponent(0.7)
        overlay.strokeColor = .clear
        overlay.position = CGPoint(x: cam.position.x, y: cam.position.y)
        overlay.zPosition = 100
        overlay.name = "deathOverlay"
        addChild(overlay)

        let deathLabel = SKLabelNode(text: "YOU DIED")
        deathLabel.fontName = "MortalKombat-Regular"
        deathLabel.fontSize = 72
        deathLabel.fontColor = .red
        deathLabel.position = CGPoint(x: 0, y: 50)
        deathLabel.zPosition = 101
        overlay.addChild(deathLabel)

        let respawnLabel = SKLabelNode(text: "tap to respawn")
        respawnLabel.fontName = "MortalKombat-Regular"
        respawnLabel.fontSize = 36
        respawnLabel.fontColor = .white
        respawnLabel.position = CGPoint(x: 0, y: -50)
        respawnLabel.zPosition = 101
        overlay.addChild(respawnLabel)

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)

        if tappedNodes.contains(where: {
            $0.name == "deathOverlay" || $0.parent?.name == "deathOverlay"
        }) {
            // Remove the overlay
            childNode(withName: "deathOverlay")?.removeFromParent()

            // Respawn
            guard
                let playerNode = player.component(ofType: SpriteComponent.self)?
                    .node
            else { return }
            if let scene = GameScene(fileNamed: "GameScene") {
                    // Match your original scale mode
                    scene.scaleMode = .aspectFill
                    
                    // Optional: add a neat transition
                    let transition = SKTransition.doorsOpenHorizontal(withDuration: 0.5)
                    self.view?.presentScene(scene, transition: transition)
                }
            playerNode.physicsBody?.velocity = .zero
            playerNode.position = spawnPoint

            let health = player.component(ofType: HealthComponent.self)
            health?.health = health?.maxHealth ?? 5
            health?.isDead = false
            health?.healingTimer = 0
            health?.updateHealthBar()

            playerNode.physicsBody?.isDynamic = true
            playerNode.isHidden = false
            playerNode.physicsBody?.velocity = .zero
            playerNode.position = spawnPoint

            joyStick.canMove = true
            
        }
        // PAUSE BUTTON
            if tappedNodes.contains(where: {
                $0.name == "pause" || $0.parent?.name == "pause"
            }) {

                if physicsWorld.speed == 1 {

                    physicsWorld.speed = 0

                    AudioManager.shared.pauseAll()

                    pause.showPauseMenu()

                } else {

                    physicsWorld.speed = 1

                    AudioManager.shared.resumeAll()

                    pause.hidePauseMenu()
                }
            }

            // RESET BUTTON
            if tappedNodes.contains(where: {
                $0.name == "resetButton" ||
                $0.parent?.name == "resetButton"
            }) {

                if let gameScene = GameScene(fileNamed: "GameScene") {

                    gameScene.scaleMode = .aspectFill

                    view?.presentScene(
                        gameScene,
                        transition: SKTransition.fade(withDuration: 0.5)
                    )
                }
            }
    }

    //before each frame
    override func update(_ currentTime: TimeInterval) {

        player.update(deltaTime: 1 / 60)

        for goat in goattone {
            goat.update(deltaTime: 1 / 60)
        }

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

        background.position = CGPoint(x: xPos, y: yPos + 100)

        cam.position.x = xPos
        cam.position.y = yPos + 100

        joyStick.position.x = xPos - (size.width / 3.3)
        joyStick.position.y = yPos - (size.height / 10)

        actionButton.position.x = xPos + (size.width / 3.3)
        actionButton.position.y = yPos - (size.height / 10)
        bulletButton.position.x = xPos + (size.width / 3.3)
        bulletButton.position.y = yPos + (size.height/3.5)
        
        
        pause.position.x = xPos - (size.width/2.5)
        pause.position.y = yPos + (size.height/2.5)

        grapple.position = CGPoint(x: xPos, y: yPos)

        abilityMeter.position.x = xPos
        abilityMeter.position.y = yPos - 240

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
        
        let involvedBoss = goattone.first { enemy in
            let enemyNode = enemy.component(ofType: SpriteComponent.self)?.node
            return contact.bodyA.node === enemyNode
                || contact.bodyB.node === enemyNode
        }

        if names.contains("grapple") && names.contains("Floor") {
            if let grappleNode = player.component(
                ofType: GrappleComponent.self
            )?.grap {
                grappleNode.physicsBody?.velocity = .zero
                grappleNode.physicsBody?.isDynamic = false
            }
            player.component(ofType: GrappleComponent.self)?.canLaunchEntity =
                true
            AudioManager.shared.playSFX(named: "GrapplePull")
        }

        if names.contains("grapple") && names.contains("player") {
            player.component(ofType: GrappleComponent.self)?.removeGrapple()
        }
        
        if names.contains("bullet") && names.contains("Floor") {

            if let bulletNode = player.component(ofType: BulletComponent.self)?.bull {
                bulletNode.physicsBody?.velocity = .zero
            }

            player.component(ofType: BulletComponent.self)?.bull?
                .removeFromParent()
        }

        if names.contains("bullet"), let enemy = involvedEnemy {
            enemy.component(ofType: HealthComponent.self)?.takeDamage(
                ammount: 1
            )
            if let bulletNode = player.component(ofType: BulletComponent.self)?
                .bull
            {
                bulletNode.physicsBody?.velocity = .zero
            }

            player.component(ofType: BulletComponent.self)?.bull?
                .removeFromParent()
            
            enemy.stateMachine.enter(ChaseState.self)
        }
        
        if names.contains("player") && names.contains("Boss Area") {
            AudioManager.shared.playMusic(named: "Goattone")
        }

        if names.contains("player") && names.contains("Floor") {

            guard let playerNode = contact.bodyA.node else { return }
            guard let floorNode = contact.bodyB.node else { return }

            let side = collisionSide(nodeA: playerNode, nodeB: floorNode)

            if side == .bottom {
                player.component(ofType: JumpComponent.self)?.isJumping = false
                player.component(ofType: GroundPoundComponent.self)?
                    .isGroundPounding = false
            }
        }

        if let enemy = involvedEnemy, names.contains("Floor") {
            guard let enemyNode = contact.bodyA.node else { return }
            guard let floorNode = contact.bodyB.node else { return }

            let side = collisionSide(nodeA: enemyNode, nodeB: floorNode)

            if side == .bottom {
                enemy.component(ofType: JumpComponent.self)?.isJumping = false
                enemy.component(ofType: GroundPoundComponent.self)?
                    .isGroundPounding = false
            }
        }

        if let boss = involvedBoss, names.contains("Floor") {
            guard let bossNode = contact.bodyA.node else { return }
            guard let floorNode = contact.bodyB.node else { return }

            let side = collisionSide(nodeA: bossNode, nodeB: floorNode)

            if side == .bottom {
                boss.component(ofType: JumpComponent.self)?.isJumping = false
                boss.component(ofType: GroundPoundComponent.self)?
                    .isGroundPounding = false
            }
        }

        if let enemy = involvedEnemy, names.contains("player") {

            guard let playerNode = player.component(ofType: SpriteComponent.self)?.node else { return }
            guard let enemyNode = enemy.component(ofType: SpriteComponent.self)?.node else { return }
            
            guard let pgp = player.component(ofType: GroundPoundComponent.self)?.isGroundPounding else  { return }
            guard let egp = enemy.component(ofType: GroundPoundComponent.self)?.isGroundPounding else  { return }
            
            let side = collisionSide(nodeA: enemyNode, nodeB: playerNode)

            enemy.lastCollisionSide = side
            print("Collision side: \(side)")

            switch side {
            case .top:
                
                // Player landed on enemy's head
                if pgp {
                    enemy.component(ofType: HealthComponent.self)?.takeDamage(
                        ammount: 1
                    )
                    player.component(ofType: GroundPoundComponent.self)?.isGroundPounding = false
                }
                // Bounce player up
                playerNode.physicsBody?.applyImpulse(CGVector(dx: Int.random(in: -100...100), dy: 350))

            case .bottom:
                // Enemy landed on player
                if egp {
                    player.component(ofType: HealthComponent.self)?.takeDamage(
                        ammount: 1
                    )
                    enemy.component(ofType: GroundPoundComponent.self)?.isGroundPounding = false
                }
                let knockbackDir: CGFloat =
                    playerNode.position.x > enemyNode.position.x ? 1 : -1
                enemyNode.physicsBody?.applyImpulse(
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

        if let boss = involvedBoss, names.contains("player") {

            guard let playerNode = player.component(ofType: SpriteComponent.self)?.node else { return }
            guard let enemyNode = boss.component(ofType: SpriteComponent.self)?.node else { return }
            
            guard let pgp = player.component(ofType: GroundPoundComponent.self)?.isGroundPounding else  { return }
            guard let bgp = boss.component(ofType: GroundPoundComponent.self)?.isGroundPounding else  { return }
            
            let side = collisionSide(nodeA: enemyNode, nodeB: playerNode)

            boss.lastCollisionSide = side
            
            switch side {
            case .top:
                // Player landed on enemy's head
                if pgp {
                    boss.component(ofType: HealthComponent.self)?.takeDamage(
                        ammount: 1
                    )
                    player.component(ofType: GroundPoundComponent.self)?.isGroundPounding = false
                }
                // Bounce player up
                playerNode.physicsBody?.applyImpulse(CGVector(dx: Int.random(in: -1000...1000), dy: 350))
                
                if boss.component(ofType: HealthComponent.self)?.health == 0 {
                    // Create a thank you label
                    let thxLabel = SKLabelNode(text: "Thank you for playing Batberg Versus DeSeaver!!!!")
                    let creditLabel = SKLabelNode(text: "Developed by: David, Diego, Jackson, James")
                    let teachLabel = SKLabelNode(text: "Special thanks to Seaver, SwedBerg, and Gattone")
                    let teachLabel2 = SKLabelNode(text: "We wouldn't have made this without you (for better or for worse)")
                    // Too lazy to make func for this instance
                    thxLabel.position = CGPoint(x: -8485.743, y: 4200.647)
                    thxLabel.fontSize = 48
                    thxLabel.fontColor = .white
                    thxLabel.zPosition = 2
                    
                    creditLabel.position = CGPoint(x: -8485.743, y: 4200.647 - 50)
                    creditLabel.fontSize = 48
                    creditLabel.fontColor = .white
                    creditLabel.zPosition = 2
                    
                    teachLabel.position = CGPoint(x: -8485.743, y: 4200.647 - 100)
                    teachLabel.fontSize = 48
                    teachLabel.fontColor = .white
                    teachLabel.zPosition = 2
                    
                    teachLabel2.position = CGPoint(x: -8485.743, y: 4200.647 - 150)
                    teachLabel2.fontSize = 48
                    teachLabel2.fontColor = .white
                    teachLabel2.zPosition = 2
                    
                    scene?.addChild(thxLabel)
                    scene?.addChild(creditLabel)
                    scene?.addChild(teachLabel)
                    scene?.addChild(teachLabel2)
                }

            case .bottom:
                // Enemy landed on player
                if bgp {
                    player.component(ofType: HealthComponent.self)?.takeDamage(
                        ammount: 1
                    )
                    boss.component(ofType: GroundPoundComponent.self)?.isGroundPounding = false
                }
                let knockbackDir: CGFloat =
                    playerNode.position.x > enemyNode.position.x ? 1 : -1
                playerNode.physicsBody?.applyImpulse(
                    CGVector(dx: 250 * knockbackDir, dy: 150)
                )
                
                if player.component(ofType: HealthComponent.self)?.health == 0 {
                    let ranVL = Int.random(in: 1...3)
                    AudioManager.shared.playSFX(named: "GoattoneVoiceLine\(ranVL)")
                }
                
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
            playerNode.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 250.0))
        }

        if names.contains("tramp0") && names.contains("player") {
            guard
                let playerNode = player.component(ofType: SpriteComponent.self)?
                    .node

            else { return }

            playerNode.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 1500.0))
        }
        
        if names.contains("fanAOE45") && names.contains("player") {
            guard
                let playerNode = player.component(ofType: SpriteComponent.self)?
                    .node

            else { return }

            playerNode.physicsBody?.applyImpulse(CGVector(dx: 10.0, dy: 10.0))
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        let names = [contact.bodyA.node?.name, contact.bodyB.node?.name]
        
        if names.contains("player") && names.contains("Floor") {
            player.component(ofType: JumpComponent.self)?.isJumping = true
            player.component(ofType: GroundPoundComponent.self)?.isGroundPounding = false
        }
        
        if names.contains("player") && names.contains("Boss Area") {
            // Makes a node that prevents the player from leaving the goattone arena
            let blockWall = SKSpriteNode(imageNamed: "Magma center")
            blockWall.size = CGSize(width: 256, height: 256)
            blockWall.position = CGPoint(x: -7222.127, y: 6213.339)
            
            blockWall.physicsBody = SKPhysicsBody(rectangleOf: blockWall.size)
            
            blockWall.physicsBody?.isDynamic = false
            blockWall.physicsBody?.allowsRotation = false
            blockWall.physicsBody?.affectedByGravity = false
            blockWall.physicsBody?.pinned = true
            
            
            blockWall.physicsBody?.contactTestBitMask = 0
            
            scene?.addChild(blockWall)
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

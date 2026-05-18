//
//  Grapple.swift
//  BatbergVersusDeSeaver
//
//  Created by DIEGO CHAVEZ on 4/27/26.
//

import Foundation
import GameplayKit

class Grapple: SKNode {

    var player = Player.shared

    var innerRadius: CGFloat
    var outerRadius: CGFloat

    private var playerRadius: SKShapeNode
    private var trajectory: SKShapeNode

    static var canGrapple = true

    var touchPosition = CGPoint(x: 0, y: 0)

    init(size: CGFloat) {

        innerRadius = size
        outerRadius = size * 2

        playerRadius = SKShapeNode(circleOfRadius: innerRadius)
        playerRadius.strokeColor = .clear

        trajectory = SKShapeNode()

        super.init()

        isUserInteractionEnabled = true
        addChild(playerRadius)
        addChild(trajectory)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        if !Grapple.canGrapple { return }

        touchPosition =
            touches.first?.location(in: playerRadius) ?? CGPoint(x: 0, y: 0)
        // create it here because the init doesn't work for some reason
        trajectory = SKShapeNode()
        trajectory.strokeColor = .white
        trajectory.lineWidth = 2
        addChild(trajectory)

    }

    private var dx: CGFloat = .zero
    private var dy: CGFloat = .zero

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        if !Grapple.canGrapple { return }

        guard let touch = touches.first else { return }
        let currentLoc = touch.location(in: playerRadius)

        dx = currentLoc.x - touchPosition.x
        dy = currentLoc.y - touchPosition.y

        let distance = sqrt(dx * dx + dy * dy)

        let angle = atan2(dy, dx)

        let path = CGRect(x: 0, y: 25, width: 10, height: distance)
        trajectory.path = CGPath(rect: path, transform: nil)

        trajectory.zRotation = angle - (.pi / 2)

    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        if !Grapple.canGrapple { return }

        trajectory.removeFromParent()
        
        if abs(dx) < 150 && abs(dy) < 150 { return }

        player.component(ofType: GrappleComponent.self)?.launch(
            vector: CGVector(dx: dx, dy: dy)
        )
        
        AbilityCoolDown.time = 1.5
        AbilityCoolDown.startCoolDown()
    }

}

class GrappleComponent: GKComponent {

    // Entity
    var sprite: SpriteComponent? {
        return entity?.component(ofType: SpriteComponent.self)
    }
    var maxAccel: CGVector = .zero
    let maxVelocity: CGFloat = 2500
    var canLaunchEntity: Bool = false
    var currentSpeed: CGFloat = .zero

    // Grapple projectile
    var grap: SKSpriteNode?
    var grappleAccel: CGVector = .zero
    var launchVector: CGVector = .zero
    var canLaunch: Bool = false
    var rope: SKShapeNode?

    override func didAddToEntity() {

        if let playerNode = entity?.component(ofType: SpriteComponent.self)?
            .node
        {
            grap = SKSpriteNode(imageNamed: "hook")
            grap?.position = playerNode.position
            grap?.setScale(0.1)
            grap?.zPosition = 0

            grap?.physicsBody = SKPhysicsBody(
                circleOfRadius: grap!.size.width / 8
            )

            grap?.physicsBody?.affectedByGravity = false
            grap?.physicsBody?.isDynamic = true

            grap?.physicsBody?.categoryBitMask = PhysicsCategory.grapple
            grap?.physicsBody?.contactTestBitMask =
                PhysicsCategory.floor | PhysicsCategory.enemy
                | PhysicsCategory.player
            grap?.physicsBody?.collisionBitMask =
                PhysicsCategory.floor | PhysicsCategory.enemy
                | PhysicsCategory.player
            grap?.physicsBody?.allowsRotation = false

            grap?.name = "grapple"
        }

    }

    func launch(vector: CGVector) {
        
        grappleAccel = .zero

        maxAccel = CGVector(dx: vector.dx / 6.5, dy: vector.dy / 6.5)
        launchVector = vector
        canLaunch = true

        guard let playerNode = sprite?.node else { return }
        guard let scene = playerNode.parent else { return }  // gameScene-ish

        let length = sqrt(vector.dx * vector.dx + vector.dy * vector.dy)
        let normalX = vector.dx / length
        let normalY = vector.dy / length
        let offsetX =
            normalX * (playerNode.size.width / 2 + (grap?.size.width ?? 0))
        let offsetY =
            normalY * (playerNode.size.height / 2 + (grap?.size.height ?? 0))

        grap?.removeFromParent()
        rope?.removeFromParent()

        grap = SKSpriteNode(imageNamed: "hook")
        grap?.position = CGPoint(
            x: playerNode.position.x + offsetX,
            y: playerNode.position.y + offsetY
        )
        grap?.zRotation = atan2(-vector.dx, vector.dy)
        grap?.setScale(0.1)
        grap?.name = "grapple"

        rope = SKShapeNode(rect: CGRect(), cornerRadius: 25)
        rope?.position = grap?.position ?? .zero
        rope?.fillColor = .white

        let body = SKPhysicsBody(circleOfRadius: (grap?.size.width ?? 0) / 8)

        body.affectedByGravity = false
        body.isDynamic = true

        body.categoryBitMask = PhysicsCategory.grapple
        body.collisionBitMask =
            PhysicsCategory.floor | PhysicsCategory.enemy
            | PhysicsCategory.player
        body.contactTestBitMask =
            PhysicsCategory.floor | PhysicsCategory.enemy
            | PhysicsCategory.player

        grap?.physicsBody = body

        scene.addChild(grap!)  // add to gameScene
        scene.addChild(rope!)

        launchVector = vector
        
        AudioManager.shared.playSFX(named: "GrappleShot")

    }

    override func update(deltaTime seconds: TimeInterval) {
        guard canLaunch else { return }

        guard let body = sprite?.node.physicsBody else { return }

        grap?.physicsBody?.velocity = CGVector(
            dx: launchVector.dx * 3,
            dy: launchVector.dy * 3
        )

        // Get actual current speed using pythagoras
        currentSpeed = sqrt(
            body.velocity.dx * body.velocity.dx + body.velocity.dy
                * body.velocity.dy
        )

        grappleAccel = CGVector(
            dx: grappleAccel.dx + maxAccel.dx,
            dy: grappleAccel.dy + maxAccel.dy
        )

        guard let playerPos = sprite?.node.position else { return }
        guard let grapPos = grap?.position else { return }

        let dx = grapPos.x - playerPos.x
        let dy = grapPos.y - playerPos.y
        let distance = sqrt(dx * dx + dy * dy)

        rope?.position = playerPos

        let path = CGRect(x: -5, y: 0, width: 2, height: distance)
        rope?.path = CGPath(rect: path, transform: nil)
        rope?.zRotation = atan2(dy, dx) - (.pi / 2)


        if canLaunchEntity {
            if currentSpeed < maxVelocity {
                sprite?.node.physicsBody?.applyForce(grappleAccel)
            } else {
                removeGrapple()
            }
        }

    }

    func removeGrapple() {
        grappleAccel = .zero
        canLaunch = false
        canLaunchEntity = false
        grap?.removeFromParent()
        rope?.removeFromParent()
        AudioManager.shared.stopAllSFX()
        AudioManager.shared.playSFX(named: "GrappleRelease")
    }

}

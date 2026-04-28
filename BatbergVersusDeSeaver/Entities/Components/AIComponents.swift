//
//  AIComponents.swift
//  BatbergVersusDeSeaver
//
//  Created by DAVID SHOW on 4/22/26.
//

import Foundation
import GameplayKit

class FollowEntityComponent: GKComponent {

    var sprite: SpriteComponent? {
        return entity?.component(ofType: SpriteComponent.self)
    }

    var move: MovementComponent? {
        return entity?.component(ofType: MovementComponent.self)
    }

    var who: GKEntity
    var velocity: CGVector = .zero
    var follow: Bool = false

    init(who: GKEntity) {
        self.who = who
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func followEntity(who: GKEntity) {

        guard
            let whoPosition = who.component(ofType: SpriteComponent.self)?.node
                .position
        else { return }
        guard let selfPosition = sprite?.node.position else { return }

        let direction: CGPoint = CGPoint(
            x: selfPosition.x - whoPosition.x,
            y: selfPosition.y - whoPosition.y
        )
        let length = sqrt(direction.x * direction.x + direction.y * direction.y)

        let normalX = -direction.x / length
        let normalY = -direction.y / length

        velocity = CGVector(dx: 400 * normalX, dy: normalY * 400)

    }

    override func update(deltaTime seconds: TimeInterval) {
        if follow {
            followEntity(who: who)
            move?.velocity = velocity
        } else {
            move?.velocity = .zero
        }
    }

}

class RadiusComponent: GKComponent {

    var sprite: SpriteComponent? {
        return entity?.component(ofType: SpriteComponent.self)
    }

    // For setting off the lineOfSight check
    var visionRange: SKShapeNode
    // Shoots a ray to detect for obstacles
    var attackRange: SKShapeNode

    init(visionRadius: CGFloat, attackRadius: CGFloat) {
        self.visionRange = SKShapeNode(circleOfRadius: visionRadius)
        self.attackRange = SKShapeNode(circleOfRadius: attackRadius)
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var isSetup = false

    override func update(deltaTime seconds: TimeInterval) {
        // Scuffed Init since didAddtoEntity sprite is nil
        if !isSetup && sprite?.node.parent != nil {
            visionRange.fillColor = .yellow
            visionRange.alpha = 0.5
            attackRange.fillColor = .red
            attackRange.alpha = 0.5

            sprite?.node.addChild(visionRange)
            sprite?.node.addChild(attackRange)

            isSetup = true
        }

        let playerPos = Player.shared.component(ofType: SpriteComponent.self)?.node.position ?? .zero

        if isInVisionRangeOfPlayer(playerPosition: playerPos) {
            entity?.component(ofType: FollowEntityComponent.self)?.follow = true
        } else {
            entity?.component(ofType: FollowEntityComponent.self)?.follow = false
        }

    }

    func isInVisionRangeOfPlayer(playerPosition: CGPoint) -> Bool {
        guard let enemyPos = sprite?.node.position else { return false }
        let dx = playerPosition.x - enemyPos.x
        let dy = playerPosition.y - enemyPos.y
        let pythag = sqrt(dx * dx + dy * dy)
        return pythag <= visionRange.frame.size.width / 2
    }
    
    func isInAttackRangeOfPlayer() {
        
    }

}

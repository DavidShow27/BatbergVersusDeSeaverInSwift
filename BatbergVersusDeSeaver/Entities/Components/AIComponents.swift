//
//  AIComponents.swift
//  BatbergVersusDeSeaver
//
//  Created by DAVID SHOW on 4/28/26.
//

import Foundation
import GameplayKit

// How enemies in this game move

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
    var flee: Bool = false

    init(who: GKEntity) {
        self.who = who
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func followEntity(who: GKEntity) {

        guard let whoPosition = who.component(ofType: SpriteComponent.self)?.node.position else { return }
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
    
    func fleeEntity(who: GKEntity) {
        guard let whoPosition = who.component(ofType: SpriteComponent.self)?.node.position else { return }
        guard let selfPosition = sprite?.node.position else { return }

        let direction: CGPoint = CGPoint(
            x: selfPosition.x - whoPosition.x,
            y: selfPosition.y - whoPosition.y
        )
        let length = sqrt(direction.x * direction.x + direction.y * direction.y)

        let normalX = direction.x / length
        let normalY = direction.y / length

        velocity = CGVector(dx: 400 * normalX, dy: normalY * 400)
    }

    override func update(deltaTime seconds: TimeInterval) {
        if follow {
            followEntity(who: who)
            move?.velocity = velocity
        } else if flee {
            fleeEntity(who: who)
            move?.velocity = velocity
        } else {
            move?.velocity = .zero
        }
    }
}

//
//  AIComponents.swift
//  BatbergVersusDeSeaver
//
//  Created by DAVID SHOW on 4/22/26.
//

import Foundation
import GameplayKit

class FollowEntityComponent : GKComponent {

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
        
        guard let whoPosition = who.component(ofType: SpriteComponent.self)?.node.position else { return }
        guard let selfPosition = sprite?.node.position else { return }
        
        let direction: CGPoint = CGPoint(x: selfPosition.x - whoPosition.x, y: selfPosition.y - whoPosition.y)
        let length = sqrt(direction.x * direction.x + direction.y * direction.y)
        
        let normalX = -direction.x / length
        let normalY = -direction.y / length

        velocity = CGVector(dx: 400 * normalX, dy: normalY * 400)
        
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        followEntity(who: who)
        move?.velocity = velocity
    }
    
}

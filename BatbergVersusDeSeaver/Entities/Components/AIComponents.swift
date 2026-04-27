//
//  AIComponents.swift
//  BatbergVersusDeSeaver
//
//  Created by DAVID SHOW on 4/22/26.
//

import Foundation
import GameplayKit

class FollowEntity : GKComponent {
    
    var sprite: SpriteComponent? {
        return entity?.component(ofType: SpriteComponent.self)
    }
    
    var move: MovementComponent? {
        return entity?.component(ofType: MovementComponent.self)
    }
    
    var actions = GKAgent()
    
    func followEntity(who: GKEntity) {
        
        guard let whoPosition = who.component(ofType: SpriteComponent.self)?.node.position else { return }
        guard let selfPosition = sprite?.node.position else { return }
        let direction: CGPoint? = CGPoint(x: selfPosition.x - whoPosition.x, y: selfPosition.y - whoPosition.y)
        //let vector: CGVector? = CGVector(dx: move?.velocity.dx.magnitude * direction.x, dy: move?.velocity.dy.magnitude * direction?.y)
        
        
    }
    
}

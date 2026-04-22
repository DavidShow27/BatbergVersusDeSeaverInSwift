//
//  MovementComponents.swift
//  BatbergVersusDeSeaver
//
//  Created by DAVID SHOW on 4/22/26.
//

import Foundation
import GameplayKit

class MovementComponent: GKComponent {
    
    var magnitude: CGFloat = 200
    var direction: CGVector = .zero
    
    // Grab the entity
    var spriteComponent: SpriteComponent? {
        return entity?.component(ofType: SpriteComponent.self)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        guard let node = spriteComponent?.node else { return }
        node.position.x += direction.dx * magnitude * CGFloat(seconds)
    }
}

class JumpComponent: GKComponent {
    var jumpStrength: CGFloat = 1000
    
    var spriteComponent: SpriteComponent? {
        return entity?.component(ofType: SpriteComponent.self)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        guard let node = spriteComponent?.node else { return }
        node.position.y += jumpStrength * CGFloat(seconds)
    }
}

class DoubleJumpComponent {
    // to add later
}

class CrouchComponent: GKComponent {
    var spriteComponent: SpriteComponent? {
        return entity?.component(ofType: SpriteComponent.self)
    }
    
    // to add later
    
}

class SlideComponent: GKComponent {
    // to add later
}

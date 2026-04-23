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
    
    override func update(deltaTime seconds: TimeInterval) {
        guard let node = entity?.component(ofType: SpriteComponent.self)?.node else { return }
        node.position.x += direction.dx * magnitude * CGFloat(seconds)
    }
}

class JumpComponent: GKComponent {
    
    var jumpStrength: CGFloat = 1000
    var jumpSpeed: CGFloat
    var isJumping: Bool = false

    func jump() {
        if isJumping { return }
        guard let node = entity?.component(ofType: SpriteComponent.self)?.node else { return }
        isJumping = true
        jumpSpeed = jumpStrength
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        // Add gravity to this somehow
        if isJumping {
            jumpSpeed -= 20
            node.position.y += jumpSpeed
        }
        // When collision Component gets added, I will have isJumping = false
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

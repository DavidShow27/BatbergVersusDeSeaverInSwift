//
//  MovementComponents.swift
//  BatbergVersusDeSeaver
//
//  Created by DAVID SHOW on 4/22/26.
//

import Foundation
import GameplayKit

class MovementComponent: GKComponent {
    
    var velocity: CGVector = .zero
    
    override func update(deltaTime seconds: TimeInterval) {
        guard let node = entity?.component(ofType: SpriteComponent.self)?.node else { return }
        node.position.x += velocity.dx * CGFloat(seconds)
    }
    
    func left() {
        velocity = CGVectorMake(-1, 0)
    }
    
    func right() {
        velocity = CGVectorMake(1, 0)
    }
    
    func stop() {
        velocity = .zero
    }
}

class JumpComponent: GKComponent {
    
    var jumpStrength: CGFloat = 400
    var isJumping: Bool = false
    
    func jump() {
        
        if isJumping { return }
        
        guard let node = entity?.component(ofType: SpriteComponent.self)?.node else { return }
        guard let body = node.physicsBody else { return }
        isJumping = true
        body.applyImpulse(CGVector(dx: 0, dy: jumpStrength))
    }
}

class GroundPoundComponent: GKComponent {
    
    var groundPoundStrength: CGFloat = -1000
    
    func groundPound() {
        guard let node = entity?.component(ofType: SpriteComponent.self)?.node else { return }
        guard let body = node.physicsBody else { return }
        
        body.applyImpulse(CGVector(dx: 0, dy: groundPoundStrength))
    }
}

class DoubleJumpComponent {
    // to add later
}

class CrouchComponent: GKComponent {
    
    var isCrouching: Bool
    
    override init() {
        isCrouching = false
        super.init()
    }
    
    var sprite: SpriteComponent? {
        return entity?.component(ofType: SpriteComponent.self)
    }
    
    var body: PhysicsComponent? {
        return entity?.component(ofType: PhysicsComponent.self)
    }
    
    func crouch() {
        if isCrouching { return }
        
        guard let node = sprite?.node else { return }

        sprite?.node.size = CGSize(width: node.size.width, height: node.size.height / 2)
        body?.applyPhysics(to: node)
        node.position.y -= (node.size.height / 2)
        
        isCrouching = true
    }
    
    func Uncrouch() {
        if !isCrouching { return }
        
        guard let node = sprite?.node else { return }
        
        sprite?.node.size = CGSize(width: node.size.width, height: node.size.height * 2)
        body?.applyPhysics(to: node)
        isCrouching = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class SlideComponent: GKComponent {
    
    var slideStrength = 400
    
    func slide() {
        guard let body = entity?.component(ofType: SpriteComponent.self)?.node.physicsBody else { return }
        guard let dir = entity?.component(ofType: MovementComponent.self)?.velocity.dx else { return }
        
        if dir > 0 {
            body.applyImpulse(CGVector(dx: slideStrength ,dy: .zero))
        } else {
            body.applyImpulse(CGVector(dx: -slideStrength ,dy: .zero))
        }
    }
}

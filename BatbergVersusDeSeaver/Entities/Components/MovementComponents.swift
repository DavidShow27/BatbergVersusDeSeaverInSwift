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
        
        if isJumping {
            entity?.component(ofType: GroundPoundComponent.self)?.groundPound()
            return
        }
        
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
    
    func crouch() {
        if isCrouching { return }
        
        guard let width = sprite?.node.size.width else { return }
        guard let height = sprite?.node.size.height else { return }

        sprite?.node.size = CGSize(width: width, height: height / 2)
        isCrouching = true
    }
    
    func Uncrouch() {
        if !isCrouching { return }
        
        guard let width = sprite?.node.size.width else { return }
        guard let height = sprite?.node.size.height else { return }
        
        sprite?.node.size = CGSize(width: width, height: height * 2)
        isCrouching = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class SlideComponent: GKComponent {
    // to add later
}

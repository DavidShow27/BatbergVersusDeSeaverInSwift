//
//  AIComponents.swift
//  BatbergVersusDeSeaver
//
//  Created by DAVID SHOW on 4/22/26.
//

import Foundation
import GameplayKit

// The actual brains of the Enemies
// decides what components to run based on conditions like distance from player

class IdleState: GKState {
    
    weak var entity: Enemy?
    
    init(entity: Enemy) {
        self.entity = entity
    }
    
    override func didEnter(from previousState: GKState?) {
        print("entering idle state")
        entity?.component(ofType: MovementComponent.self)?.stop()
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        guard let entity = entity else { return }
        
        let playerPos = Player.shared.component(ofType: SpriteComponent.self)?.node.position ?? .zero
        let selfPos = entity.component(ofType: SpriteComponent.self)?.node.position ?? .zero
        
        let dx = playerPos.x - selfPos.x
        let dy = playerPos.y - selfPos.y
        let distance = sqrt(dx * dx + dy * dy)

        if distance < 700 {
            stateMachine?.enter(ChaseState.self)
        }
        
    }
    
    override func willExit(to nextState: GKState) {
        print("leaving idle state")
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == ChaseState.self
    }
    
}

class ChaseState : GKState {
    
    weak var entity: Enemy?
    
    init(entity: Enemy) {
        self.entity = entity
    }
    
    override func didEnter(from previousState: GKState?) {
        print("entering chasing state")
        entity?.component(ofType: FollowEntityComponent.self)?.flee = false
        entity?.component(ofType: FollowEntityComponent.self)?.follow = true
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        guard let entity = entity else { return }
                
        let playerPos = Player.shared.component(ofType: SpriteComponent.self)?.node.position ?? .zero
        let selfPos = entity.component(ofType: SpriteComponent.self)?.node.position ?? .zero
                
        let dx = playerPos.x - selfPos.x
        let dy = playerPos.y - selfPos.y
        let distance = sqrt(dx * dx + dy * dy)
                
        // Close enough to attack
        if distance < 300 {
            stateMachine?.enter(AttackState.self)
        }
                
        // Lost the player
        if distance > 700 {
            stateMachine?.enter(IdleState.self)
        }
        
        switch entity.lastCollisionSide {
        case .top:
            break
        case .bottom:
            break
        case .left:
            break
        case .right:
            break
        case .reset:
            break
        }

    }
    
    override func willExit(to nextState: GKState) {
        entity?.component(ofType: FollowEntityComponent.self)?.follow = false
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == IdleState.self || stateClass == AttackState.self || stateClass == FleeState.self
    }
    
}

class AttackState: GKState {
    
    weak var entity: Enemy?
    
    init(entity: Enemy) {
        self.entity = entity
    }
    
    override func didEnter(from previousState: GKState?) {
        print("entering attack state")
        entity?.lastCollisionSide = .reset
        entity?.component(ofType: FollowEntityComponent.self)?.follow = true
        entity?.component(ofType: AttackEntityComponent.self)?.attack = true
        entity?.component(ofType: SlideComponent.self)?.isSliding = false
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
        guard let entity = entity else { return }
                
        let playerPos = Player.shared.component(ofType: SpriteComponent.self)?.node.position ?? .zero
        let selfPos = entity.component(ofType: SpriteComponent.self)?.node.position ?? .zero
                
        let dx = playerPos.x - selfPos.x
        let dy = playerPos.y - selfPos.y
        let distance = sqrt(dx * dx + dy * dy)
                
        // far away
        if distance > 300 {
            stateMachine?.enter(ChaseState.self)
        }
        
        switch entity.lastCollisionSide {
        case .top:
            entity.component(ofType: FollowEntityComponent.self)?.follow = false
            entity.component(ofType: FollowEntityComponent.self)?.flee = true
        case .bottom:
            entity.component(ofType: SlideComponent.self)?.slide()
        case .left:
            entity.component(ofType: JumpComponent.self)?.jump()
        case .right:
            entity.component(ofType: JumpComponent.self)?.jump()
        case .reset:
            break
        }

    }
    
    override func willExit(to nextState: GKState) {
        entity?.component(ofType: AttackEntityComponent.self)?.attack = false
        entity?.component(ofType: CrouchComponent.self)?.isCrouching = false
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == ChaseState.self || stateClass == FleeState.self || stateClass == IdleState.self
    }
}

class FleeState: GKState {
    
    weak var entity: Enemy?
    
    init(entity: Enemy) {
        self.entity = entity
    }
    
    override func didEnter(from previousState: GKState?) {
        // Reverse follow direction to run away
        entity?.component(ofType: FollowEntityComponent.self)?.flee = true
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == IdleState.self || stateClass == ChaseState.self
    }
}

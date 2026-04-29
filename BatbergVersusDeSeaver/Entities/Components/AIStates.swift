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

        if distance < 500 {
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
        if distance < 200 {
            stateMachine?.enter(AttackState.self)
        }
                
        // Lost the player
        if distance > 500 {
            stateMachine?.enter(IdleState.self)
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
        //entity?.component(ofType: AttackComponent.self)?.attack()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == ChaseState.self || stateClass == FleeState.self
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
        return stateClass == IdleState.self
    }
}

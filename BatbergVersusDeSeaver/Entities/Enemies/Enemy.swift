//
//  Enemy.swift
//  BatbergVersusDeSeaver
//
//  Created by JACKSON GERAMBIA on 4/21/26.
//

import Foundation
import GameplayKit

// Will change name to EnemyEntity once completed
// Then every enemy will inherit from this
// treat this like an abstract class
class Enemy: GKEntity {
    
    var lastCollisionSide: CollisionSide = .reset
    
    static let shared = Enemy()
    
    var stateMachine : GKStateMachine!
    
    override init() {
        super.init()
        setUp()
    }
    
    // Called when using Story-Board
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    private func setUp() {
        addComponent(PhysicsComponent())
        addComponent(MovementComponent())
        addComponent(JumpComponent())
        addComponent(GroundPoundComponent())
        addComponent(CrouchComponent())
        addComponent(SlideComponent())
        addComponent(FollowEntityComponent(who: Player.shared))
        addComponent(AttackEntityComponent(who: Player.shared))
        
        stateMachine = GKStateMachine(states: [
            IdleState(entity: self),
            ChaseState(entity: self),
            AttackState(entity: self),
            FleeState(entity: self)
        ])
        
        stateMachine.enter(IdleState.self)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        stateMachine.update(deltaTime: seconds)
    }
    
}

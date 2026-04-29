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
        addComponent(SpriteComponent(imageName: "BatBergPlaceHolder"))
        addComponent(PhysicsComponent())
        addComponent(MovementComponent())
        addComponent(JumpComponent())
        addComponent(GroundPoundComponent())
        addComponent(FollowEntityComponent(who: Player.shared))
        addComponent(RadiusComponent(visionRadius: 600, attackRadius: 200))
        addComponent(HealthComponent(health: 1))
    }
    
}

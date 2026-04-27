//
//  Enemy.swift
//  BatbergVersusDeSeaver
//
//  Created by JACKSON GERAMBIA on 4/21/26.
//

import Foundation
import GameplayKit

class Enemy: GKEntity {
    
    static let shared = Enemy()
    
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
        addComponent(MovementComponent())
        addComponent(PhysicsComponent())
        addComponent(JumpComponent())
        addComponent(GroundPoundComponent())
        addComponent(FollowEntityComponent(who: Player.shared))
    }
}

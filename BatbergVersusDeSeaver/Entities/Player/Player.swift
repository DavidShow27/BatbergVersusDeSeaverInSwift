//
//  Player.swift
//  BatbergVersusDeSeaver
//
//  Created by DAVID SHOW on 4/20/26.
//

import Foundation
import GameplayKit

class Player: GKEntity {
    
    static let shared = Player()
    
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
        addComponent(CrouchComponent())
        addComponent(SlideComponent())
    }
}

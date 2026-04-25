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
        addComponent(SpriteComponent(imageName: "BatBergPlaceHolder"))
        addComponent(MovementComponent())
        addComponent(JumpComponent())
        addComponent(GroundPoundComponent())
        addComponent(CrouchComponent())
        
        if let node = self.component(ofType: SpriteComponent.self)?.node.physicsBody {
            node.restitution = 0.0
            node.categoryBitMask = 1
            node.contactTestBitMask = 1
        }
    }
    
    // This is only for the SpriteKit because it is Objective-C
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

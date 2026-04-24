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
        
    }
    
    // This is only for the SpriteKit because it is Objective-C
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

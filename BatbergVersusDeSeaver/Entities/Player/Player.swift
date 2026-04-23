//
//  Player.swift
//  BatbergVersusDeSeaver
//
//  Created by DAVID SHOW on 4/20/26.
//

import Foundation
import SpriteKit

class Player: SKNode {
    
    // Stats
    var health: Int
    var ability: Bool
    
    // Movement
    var xSpeed: CGFloat
    var ySpeed: CGFloat
    var jumping: Bool
    var groundPound: Bool
    var sliding: Bool
    var crouch: Bool
    
    // Graphics
    var sprite: SKSpriteNode
    
    // Init
    override init() {
        self.health = 100
        self.ability = false
        self.jumping = false
        self.groundPound = false
        self.sliding = false
        self.crouch = false
        self.xSpeed = 0
        self.ySpeed = 0
        self.sprite = SKSpriteNode(imageNamed: "BatbergPlaceHolder")
        
        // Get stuff from SKNode
        super.init()
        addComponent(SpriteComponent(imageName: "BatbergPlaceHolder"))
        addComponent(MovementComponent())
        addComponent(JumpComponent())
    }
    
    // This is only for the SpriteKit because it is Objective-C
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

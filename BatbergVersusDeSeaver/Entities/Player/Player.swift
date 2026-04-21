//
//  Player.swift
//  BatbergVersusDeSeaver
//
//  Created by DAVID SHOW on 4/20/26.
//

import Foundation
import SpriteKit

class Player {
    
    // Stats
    var health: Int
    var ability: Bool
    
    // Movement
    enum direction {
        case left
        case right
    }
    var jumping: Bool
    var groundPound: Bool
    var sliding: Bool
    var crouch: Bool
    
    // Graphics
    var sprite: SKSpriteNode
    
    // Init
    init() {
        self.health = 100
        self.ability = false
        self.jumping = false
        self.groundPound = false
        self.sliding = false
        self.crouch = false
        
        self.sprite = SKSpriteNode(imageNamed: "BatbergPlaceHolder")
    }
}

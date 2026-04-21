//
//  Player.swift
//  BatbergVersusDeSeaver
//
//  Created by DAVID SHOW on 4/20/26.
//

import Foundation

class Player {
    // Stats
    var health: Int
    var ability: Bool
    // Movement
    enum direction {
        case up
        case down
        case left
        case right
    }
    var groundPound: Bool
    var sliding: Bool
    var crouch: Bool
    // Init
    init(health: Int, ability: Bool, groundPound: Bool, sliding: Bool, crouch: Bool) {
        self.health = health
        self.ability = ability
        self.groundPound = groundPound
        self.sliding = sliding
        self.crouch = crouch
    }
}

//
//  Enemy.swift
//  BatbergVersusDeSeaver
//
//  Created by JACKSON GERAMBIA on 4/21/26.
//

import Foundation

class Enemy {
    
    var name: String
    //Stats
    var health: Int
    var speed: Double
    var dmg: Int
    var ability: Bool
    
    var image: String
    //Movement(Same as player)
    enum direction {
        case up
        case down
        case left
        case right
    }
    //Init
    init(name: String, health: Int, speed: Double, dmg: Int, ability: Bool, image: String) {
        self.name = name
        self.health = health
        self.speed = speed
        self.dmg = dmg
        self.ability = ability
        self.image = image
    }
}

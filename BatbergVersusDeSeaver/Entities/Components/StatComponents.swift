//
//  StatComponents.swift
//  BatbergVersusDeSeaver
//
//  Created by DAVID SHOW on 4/22/26.
//

import Foundation
import GameplayKit

class SpriteComponent: GKComponent {
    var node: SKSpriteNode
    
    init(imageName: String) {
        node = SKSpriteNode(imageNamed: imageName)
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class HealthComponent: GKComponent {
    var health: Int
    
    init(health: Int) {
        self.health = health
        super.init()
    }

    init() {
        health = 100
        super.init()
    }

    func takeDamage(ammount: Int) {
        health -= ammount
    }
        
}

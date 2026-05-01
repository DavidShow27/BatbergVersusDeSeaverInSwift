//
//  Grapple.swift
//  BatbergVersusDeSeaver
//
//  Created by DIEGO CHAVEZ on 4/27/26.
//

import Foundation
import GameplayKit

class Grapple: GKComponent{
    var velocity: CGVector
    var playerPosition: CGPoint
    var grapplePosition: CGPoint
    var gravity: CGFloat = 0.98
    var ground: CGFloat
    
    init(velocity: CGVector, playerPosition: CGPoint, ground: CGFloat) {
        self.velocity = velocity
        self.playerPosition = playerPosition
        grapplePosition = playerPosition
        self.ground = ground
        super.init()
    }
    
    func launch(with force: CGVector){
        velocity = force
    }
    func update(detalTime seconds :TimeInterval){
        grapplePosition.x += velocity.dx
        grapplePosition.y += velocity.dx
        
        velocity.dy = velocity.dy - gravity
        
        if grapplePosition.y >= ground {
            grapplePosition.y = ground
            velocity = .zero
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  Grapple.swift
//  BatbergVersusDeSeaver
//
//  Created by DIEGO CHAVEZ on 4/27/26.
//

import Foundation
import GameplayKit

class Grapple: SKNode {
    
    let grappleAccel: CGFloat = 10
    let maxVelocity: CGFloat = 100
    var launch = false
    
    var player = Player.shared
    
    var innerRadius: CGFloat
    var outerRadius: CGFloat
    
    private var playerRadius: SKShapeNode
    private var grappleRange: SKShapeNode
    private var trajectory: SKShapeNode
    
    var touchPosition = CGPoint(x: 0, y: 0)
    
    init(size: CGFloat) {
        
        innerRadius = size
        outerRadius = size * 2
        
        playerRadius = SKShapeNode(circleOfRadius: innerRadius)
        
        grappleRange = SKShapeNode(circleOfRadius: outerRadius)
        
        trajectory = SKShapeNode()
        
        super.init()
        
        isUserInteractionEnabled = true
        addChild(grappleRange)
        addChild(playerRadius)
        addChild(trajectory)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        touchPosition = touches.first?.location(in: playerRadius) ?? CGPoint(x: 0, y: 0)
        // create it here because the init doesn't work for some reason
        trajectory = SKShapeNode()
        trajectory.strokeColor = .white
        trajectory.lineWidth = 2
        addChild(trajectory)
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            
        guard let touch = touches.first else { return }
        let currentLoc = touch.location(in: playerRadius)

        let dx = currentLoc.x - touchPosition.x
        let dy = currentLoc.y - touchPosition.y
        
        let distance = sqrt(dx * dx + dy * dy)
        
        let angle = atan2(dy, dx)

        let path = CGRect(x: 0, y: 25, width: 10, height: distance)
        trajectory.path = CGPath(rect: path, transform: nil)
        
        trajectory.zRotation = angle - (.pi / 2)
        
        print("pulling")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        trajectory.removeFromParent()
    }
    
}

class GrappleComponent: GKComponent {
    
    var launch: Bool = false
    
    override func update(deltaTime seconds: TimeInterval) {
        if launch {
            
            //let fromPos = sprite?.node.position ?? .zero
                    
            //let dx = playerPos.x - selfPos.x
            //let dy = playerPos.y - selfPos.y
            //let distance = sqrt(dx * dx + dy * dy)
            
            //guard let body = sprite?.node.physicsBody else { return }
            
            
        }
    }
    
}

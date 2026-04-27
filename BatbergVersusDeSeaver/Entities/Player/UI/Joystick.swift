//
//  Joystick.swift
//  BatbergVersusDeSeaver
//
//  Created by DAVID SHOW on 4/24/26.
//

import Foundation
import GameplayKit
import SpriteKit

class Joystick: SKNode {

    var knob: SKShapeNode
    var edge: SKShapeNode

    var outerRadius: CGFloat
    var innerRadius: CGFloat

    var velocity: CGVector
    var player = Player.shared
    
    // ONLY for the actionButton
    var onCrouchChanged: ((Bool) -> Void)?

    init(size: CGFloat) {

        outerRadius = size
        innerRadius = size / 2
        velocity = .zero

        self.knob = SKShapeNode(circleOfRadius: innerRadius)
        self.edge = SKShapeNode(circleOfRadius: outerRadius)
        
        knob.name = "knob"

        knob.fillColor = .white
        edge.fillColor = .clear
        edge.strokeColor = .white
        edge.lineWidth = 2.0

        knob.position = CGPoint(x: edge.frame.midX, y: edge.frame.midY)
        
        super.init()
        addChild(edge)
        addChild(knob)

        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        outerRadius = 100
        innerRadius = 100 / 2
        velocity = .zero
        
        self.knob = SKShapeNode(circleOfRadius: outerRadius)
        self.edge = SKShapeNode(circleOfRadius: innerRadius)
        
        knob.name = "knob"

        knob.fillColor = .white
        edge.fillColor = .clear
        edge.strokeColor = .white
        edge.lineWidth = 2.0
        
        super.init(coder: aDecoder)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        guard let touch = touches.first else { return }
        let location = touch.location(in: edge)

        // Get the radius by using pythag
        let dx = location.x
        let dy = location.y
        let distance = sqrt(dx * dx + dy * dy)

        // inverse Tangent on the two legs to get angle in radians
        let angle = atan2(dy, dx)

        // Clamp knob so that it doesn't go outside of the outerCircle
        if distance <= outerRadius {
            knob.position = CGPoint(x: dx, y: dy)
        } else {
            // plug it in to x and y trig functions so that it stays in a circle
            // ‾\_/‾\_/‾\_/‾\_/‾\_/‾\_/‾\_/‾\_/‾\_/‾\_/‾\_/‾\_/‾\_/‾\_/‾\_/‾\_/‾\_/‾\_/‾\_/‾
            knob.position = CGPoint(
                x: cos(angle) * outerRadius,
                y: sin(angle) * outerRadius
            )
        }
        
        // segment of a circle
        let isInLowerSegment = angle < -0.5 && angle > -2.6
        let isNearEdge = distance > outerRadius * 0.7
        guard let isInTheAir = player.component(ofType: JumpComponent.self)?.isJumping else { return }
        guard let crouching = player.component(ofType: CrouchComponent.self)?.isCrouching else { return }

        if isInLowerSegment && isNearEdge {
            player.component(ofType: CrouchComponent.self)?.crouch()
            if isInTheAir {
                player.component(ofType: GroundPoundComponent.self)?.groundPound()
            }
        } else {
            player.component(ofType: CrouchComponent.self)?.Uncrouch()
        }
        
        onCrouchChanged?(crouching)
        
        velocity = CGVector(dx: knob.position.x * 5, dy: knob.position.y * 5)

        player.component(ofType: MovementComponent.self)?.velocity = velocity
        
        // Change Sprite direction depending on velocity
        if velocity.dx > 0 {
            player.component(ofType: SpriteComponent.self)?.node.xScale = 1
        } else if velocity.dx < 0 {
            player.component(ofType: SpriteComponent.self)?.node.xScale = -1
        }

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        knob.run(SKAction.move(to: .zero, duration: .zero))
        player.component(ofType: MovementComponent.self)?.velocity = .zero
        player.component(ofType: CrouchComponent.self)?.Uncrouch()
        
        guard let crouching = player.component(ofType: CrouchComponent.self)?.isCrouching else { return }
        onCrouchChanged?(crouching)
    }

}

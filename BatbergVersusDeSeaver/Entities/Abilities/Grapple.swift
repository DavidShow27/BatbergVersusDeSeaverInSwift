//
//  Grapple.swift
//  BatbergVersusDeSeaver
//
//  Created by DIEGO CHAVEZ on 4/27/26.
//

import Foundation
import GameplayKit

class Grapple: SKNode {

    var player = Player.shared

    var innerRadius: CGFloat
    var outerRadius: CGFloat

    private var playerRadius: SKShapeNode
    private var trajectory: SKShapeNode

    var touchPosition = CGPoint(x: 0, y: 0)

    init(size: CGFloat) {

        innerRadius = size
        outerRadius = size * 2

        playerRadius = SKShapeNode(circleOfRadius: innerRadius)

        trajectory = SKShapeNode()

        super.init()

        isUserInteractionEnabled = true
        addChild(playerRadius)
        addChild(trajectory)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        touchPosition =
            touches.first?.location(in: playerRadius) ?? CGPoint(x: 0, y: 0)
        // create it here because the init doesn't work for some reason
        trajectory = SKShapeNode()
        trajectory.strokeColor = .white
        trajectory.lineWidth = 2
        addChild(trajectory)

    }

    private var dx: CGFloat = .zero
    private var dy: CGFloat = .zero

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        guard let touch = touches.first else { return }
        let currentLoc = touch.location(in: playerRadius)

        dx = currentLoc.x - touchPosition.x
        dy = currentLoc.y - touchPosition.y

        let distance = sqrt(dx * dx + dy * dy)

        let angle = atan2(dy, dx)

        let path = CGRect(x: 0, y: 25, width: 10, height: distance)
        trajectory.path = CGPath(rect: path, transform: nil)

        trajectory.zRotation = angle - (.pi / 2)

        print("pulling")
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        trajectory.removeFromParent()
        player.component(ofType: GrappleComponent.self)?.launch(
            vector: CGVector(dx: dx, dy: dy)
        )
    }

}

class GrappleComponent: GKComponent {

    var sprite: SpriteComponent? {
        return entity?.component(ofType: SpriteComponent.self)
    }

    var grappleAccel: CGVector = .zero
    var maxAccel: CGVector = .zero
    let maxVelocity: CGFloat = 1750
    var canLaunch: Bool = false

    func launch(vector: CGVector) {
        maxAccel = CGVector(dx: vector.dx * 50, dy: vector.dy * 50)
        canLaunch = true
    }

    override func update(deltaTime seconds: TimeInterval) {
        if !canLaunch { return }
        guard let body = sprite?.node.physicsBody else { return }

        // Get actual current speed using pythagoras
        let currentSpeed = sqrt(
            body.velocity.dx * body.velocity.dx +
            body.velocity.dy * body.velocity.dy
        )
        
        grappleAccel = CGVector(dx: grappleAccel.dx + maxAccel.dx / 50, dy: grappleAccel.dy + maxAccel.dy / 50)

        if currentSpeed < maxVelocity {
            body.applyForce(grappleAccel)
        } else {
            grappleAccel = .zero
            canLaunch = false
        }

    }

}

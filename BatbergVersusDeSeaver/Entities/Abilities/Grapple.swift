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
    var grap: SKSpriteNode?
    
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
        if let playerNode = player.component(ofType: SpriteComponent.self)?.node {
            
            let worldPos = playerNode.parent?.convert(playerNode.position, to: self.scene!) ?? .zero
            grap = SKSpriteNode(imageNamed: "hook")
            grap?.position = worldPos
            grap?.setScale(0.1)
            grap?.zPosition = 999
            grap?.physicsBody = SKPhysicsBody(circleOfRadius: grap!.size.width / 2)
            grap?.physicsBody?.contactTestBitMask = PhysicsCategory.floor | PhysicsCategory.enemy
            grap?.physicsBody?.categoryBitMask = PhysicsCategory.grapple
            grap?.physicsBody?.collisionBitMask = PhysicsCategory.floor | PhysicsCategory.enemy
            grap?.name = "grapple"
            self.scene?.addChild(grap!)
        }
        print("GRAP")
        player.component(ofType: GrappleComponent.self)?.launch(
            vector: CGVector(dx: dx, dy: dy),
            node: grap ?? SKSpriteNode(imageNamed: "")
        )
    }
    
    
}

class GrappleComponent: GKComponent {
    
    var sprite: SpriteComponent? {
        return entity?.component(ofType: SpriteComponent.self)
    }
    
    var grappleNode: SKSpriteNode = SKSpriteNode(imageNamed: "")
    var grappleAccel: CGVector = .zero
    var maxAccel: CGVector = .zero
    let maxVelocity: CGFloat = 1750
    var canLaunch: Bool = false
    var gravity: CGFloat = 1
    var launchVector: CGVector = .zero
    var currentSpeed:CGFloat = .zero
    
    
    
    func launch(vector: CGVector,node: SKSpriteNode) {
        maxAccel = CGVector(dx: vector.dx * 50, dy: vector.dy * 50)
        canLaunch = true
        launchVector = vector
        grappleNode = node
        canLaunch = true
        
        //grappleNode.position = sprite?.node.position ?? .zero
        let body = SKPhysicsBody(circleOfRadius: node.size.width / 2)
            body.affectedByGravity = false
            body.isDynamic = true

            body.categoryBitMask = PhysicsCategory.grapple
            body.collisionBitMask = PhysicsCategory.floor | PhysicsCategory.enemy
            body.contactTestBitMask = PhysicsCategory.floor | PhysicsCategory.enemy // optional

            grappleNode.physicsBody = body
        
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        guard canLaunch else { return }
        
        guard let body = sprite?.node.physicsBody else { return }
        
        grappleNode.physicsBody?.velocity = CGVector(
            dx: launchVector.dx * 3,
            dy: launchVector.dy * 3
        )
        
        
        grappleNode.position.x += launchVector.dx * seconds * 3
        grappleNode.position.y += launchVector.dy * seconds * 3
        // Get actual current speed using pythagoras
        currentSpeed = sqrt(
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

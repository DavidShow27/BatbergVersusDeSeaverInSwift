//
//  Enemy.swift
//  BatbergVersusDeSeaver
//
//  Created by JACKSON GERAMBIA on 4/21/26.
//

import Foundation
import GameplayKit

class Enemy: GKEntity {
    
    static let shared = Enemy()
    
    var agent = GKAgent2D()
    var playerAgent = GKAgent2D()
    
    override init() {
        super.init()
        initAgent()
        setUp()
    }
    
    // Called when using Story-Board
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initAgent()
        setUp()
    }
    
    private func initAgent() {
        agent.maxSpeed = 400
        agent.maxAcceleration = 0
        agent.mass = 1
        agent.radius = 50
        
        // Seek — move toward a target agent
        let seekAgent = GKGoal(toSeekAgent: playerAgent)

        // Flee — move away from a target agent
        let fleeAgent = GKGoal(toFleeAgent: playerAgent)

        // Follow path — follow a specific path
        //let followPath = GKGoal(toFollow: path, maxPredictionTime: 1.0, forward: true)

        // Avoid obstacles
        //let avoid = GKGoal(toAvoid: obstacles, maxPredictionTime: 1.0)

        // Stay within bounds
        //let stayWith = GKGoal(toStayOn: path, maxPredictionTime: 1.0)

        // Wander — random movement
        let wander = GKGoal(toWander: 100)  // speed

        // Separate from other agents — avoid crowding
        //let seperateFrom = GKGoal(toSeparateFrom: agents, maxDistance: 100, maxAngle: .pi)
        
        agent.behavior = GKBehavior(goals: [seekAgent, fleeAgent, wander], andWeights: [1.0, 0.5, 0.5])
    }
    
    private func setUp() {
        addComponent(SpriteComponent(imageName: "BatBergPlaceHolder"))
        addComponent(PhysicsComponent())
        addComponent(MovementComponent())
        addComponent(JumpComponent())
        addComponent(GroundPoundComponent())
        //addComponent(FollowEntityComponent(who: Player.shared))
        //addComponent(RadiusComponent(visionRadius: 600, attackRadius: 200))
        addComponent(AgentComponent(agent: agent))
    }
    
}

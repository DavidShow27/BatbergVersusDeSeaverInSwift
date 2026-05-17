//
//  GrappleCoolDown.swift
//  BatbergVersusDeSeaver
//
//  Created by DAVID SHOW on 5/14/26.
//

import Foundation
import SpriteKit

class AbilityCoolDown : SKNode {
    
    static var timer: Timer?
    static var onGoing = false
    static var time: TimeInterval = 1.5
    
    // Cool down bar nodes
    private static var coolDownBackground: SKShapeNode = SKShapeNode()
    private static var coolDownBarFill: SKShapeNode = SKShapeNode()
    
    init(size: CGSize) {

        AbilityCoolDown.coolDownBackground = SKShapeNode(rectOf: size, cornerRadius: 2)
        
        AbilityCoolDown.coolDownBackground.fillColor = UIColor.clear
        AbilityCoolDown.coolDownBackground.strokeColor = UIColor.clear
        AbilityCoolDown.coolDownBackground.lineWidth = 2

        AbilityCoolDown.coolDownBarFill = SKShapeNode(rectOf: size, cornerRadius: 2)
        AbilityCoolDown.coolDownBarFill.fillColor = UIColor.white
        AbilityCoolDown.coolDownBarFill.strokeColor = UIColor.clear
        AbilityCoolDown.coolDownBarFill.position = AbilityCoolDown.coolDownBackground.position
        
        super.init()
        
        addChild(AbilityCoolDown.coolDownBackground)
        addChild(AbilityCoolDown.coolDownBarFill)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func startProgressBar() {
        
        coolDownBarFill.alpha = 1
        coolDownBarFill.xScale = 0
        
        let grow = SKAction.scaleX(to: 1, duration: time)
        grow.timingMode = .easeOut
        
        let flash1 = SKAction.fadeAlpha(to: 0, duration: 0.1)
        flash1.timingMode = .linear
        let flash2 = SKAction.fadeAlpha(to: 1, duration: 0.1)
        flash2.timingMode = .linear
        coolDownBarFill.run(SKAction.sequence([grow,flash1,flash2]))

    }
    
    static func startCoolDownG() {
        Grapple.canGrapple = false
        startProgressBar()
        timer = Timer.scheduledTimer(withTimeInterval: time, repeats: false, block: { _ in            Grapple.canGrapple = true
        })
    }
    
    static func startCoolDownB() {
        
        BulletButton.canShoot = false
        startProgressBar()
        timer = Timer.scheduledTimer(withTimeInterval: time, repeats: false, block: { _ in            BulletButton.canShoot = true
        })
    }
    
}

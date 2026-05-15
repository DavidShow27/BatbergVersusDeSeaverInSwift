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
        coolDownBarFill.xScale = 1
        
        let shrink = SKAction.scaleX(to: 0, duration: time)
        shrink.timingMode = .linear
        
        coolDownBarFill.run(shrink)
    }
    
    static func startCoolDown() {
        print("cool down started")
        Grapple.canGrapple = false
        startProgressBar()
        timer = Timer.scheduledTimer(withTimeInterval: time, repeats: false, block: { _ in
            print("Cool Down complete")
            Grapple.canGrapple = true
            coolDownBarFill.alpha = 0
            coolDownBarFill.xScale = 1
            let appear = SKAction.fadeAlpha(to: 1.0, duration: 0.5)
            appear.timingMode = .linear
            coolDownBarFill.run(appear)
        })
    }
    
}

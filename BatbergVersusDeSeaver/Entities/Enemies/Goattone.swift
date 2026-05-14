//
//  Goattone.swift
//  BatbergVersusDeSeaver
//
//  Created by DAVID SHOW on 5/12/26.
//

import Foundation
import GameplayKit

class Goattone : Enemy {
    
    override init() {
        super.init()
        addComponent(BulletComponent())
    }
    
    @MainActor required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        if stateMachine.isEqual(AttackState.self) {
            Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { time in
                self.component(ofType: BulletComponent.self)?.fire()
            }
        }
    }
    
}

//
//  DeSeaver.swift
//  BatbergVersusDeSeaver
//
//  Created by DAVID SHOW on 5/12/26.
//

import Foundation
import GameplayKit

class DeSeaver : Enemy {
    
    override init() {
        super.init()
    }
    
    @MainActor required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

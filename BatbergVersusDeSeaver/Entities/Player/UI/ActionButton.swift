//
//  ActionButton.swift
//  BatbergVersusDeSeaver
//
//  Created by DAVID SHOW on 4/26/26.
//

import Foundation
import GameplayKit

class ActionButton: UIButton {
    
    var rectangle: CGRect
    
    override init(frame: CGRect) {
        self.rectangle = frame
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

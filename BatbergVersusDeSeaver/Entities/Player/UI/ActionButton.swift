//
//  ActionButton.swift
//  BatbergVersusDeSeaver
//
//  Created by DAVID SHOW on 4/26/26.
//

import Foundation
import GameplayKit

class ActionButton: SKNode {

    var player = Player.shared
    
    enum text: String {
        case jump
        case slide
    }
    
    var label: SKLabelNode
    private var backGround: SKShapeNode

    init(size: CGSize) {
        backGround = SKShapeNode(rectOf: size, cornerRadius: 25)
        backGround.fillColor = .clear
        backGround.strokeColor = .white
        backGround.lineWidth = 2
        label = SKLabelNode(text: text.jump.rawValue)
        label.fontSize = 48
        label.fontColor = .white
        super.init()
        isUserInteractionEnabled = true
        addChild(backGround)
        addChild(label)
    }

    required init?(coder: NSCoder) {
        backGround = SKShapeNode(rectOf: CGSize(width: 100, height: 100), cornerRadius: 25)
        backGround.fillColor = .clear
        backGround.strokeColor = .white
        backGround.lineWidth = 10
        label = SKLabelNode(text: text.jump.rawValue)
        label.fontSize = 48
        label.fontColor = .white
        super.init(coder: coder)
        isUserInteractionEnabled = true
        addChild(backGround)
        addChild(label)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if player.component(ofType: CrouchComponent.self)?.isCrouching == true {
            player.component(ofType: SlideComponent.self)?.slide()
        } else {
            player.component(ofType: JumpComponent.self)?.jump()
        }
    }

}

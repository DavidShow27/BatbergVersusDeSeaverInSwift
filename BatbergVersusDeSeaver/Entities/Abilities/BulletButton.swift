import Foundation
import GameplayKit

class ActionButton: SKNode {

    var player = Player.shared
    
    var label: SKLabelNode
    private var backGround: SKShapeNode

    init(size: CGSize) {
        backGround = SKShapeNode(rectOf: size, cornerRadius: 25)
        backGround.fillColor = .clear
        backGround.strokeColor = .white
        backGround.lineWidth = 2
        label = SKLabelNode(text: "shoot")
        label.fontName = "MortalKombat-Regular"
        label.fontSize = 48
        label.fontColor = .white
        super.init()
        isUserInteractionEnabled = true
        addChild(backGround)
        addChild(label)
        label.position.y = backGround.frame.midY
    }

    required init?(coder: NSCoder) {
        backGround = SKShapeNode(rectOf: CGSize(width: 100, height: 100), cornerRadius: 25)
        backGround.fillColor = .clear
        backGround.strokeColor = .white
        backGround.lineWidth = 10
        label = SKLabelNode(text: "shoot")
        label.fontName = "MortalKombat-Regular"
        label.fontSize = 48
        label.fontColor = .white
        super.init(coder: coder)
        isUserInteractionEnabled = true
        addChild(backGround)
        addChild(label)
    }
}

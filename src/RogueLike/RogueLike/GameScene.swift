//
//  GameScene.swift
//  RogueLike
//
//  Created by Starfighter Dollie on 1/22/25.
//

import SpriteKit
import GameplayKit


class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
   
    
    override func didMove(to view: SKView) {
        

//        let floor = DungeonPrintScene()
//        floor.position = CGPoint(x: 0, y: 0)
//        addChild(floor)
//        
        setSetting()

        
    }
    
    func setSetting() {
        self.backgroundColor = SKColor.systemFill
        // Создаем SKLabelNode

        
        // Добавляем метку на сцену
      
    }

    func mtText() {
        let label = SKLabelNode(text: "r")
        label.color = SKColor.red
        label.fontSize = 40 // Поменяйте размер текста на более разумный
        label.position = CGPoint(x: frame.midX, y: frame.midY - 100) //
        self.addChild(label)
    }
    
    
    
}


// ИГРОК
class PlayerEntityScene: SKSpriteNode  {
    init() {
        let knightTexture = SKTexture(imageNamed: "player")
        super.init(texture: knightTexture, color: UIColor.clear, size: knightTexture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//ПОДЪЗЕМЕЛЬЕ
    

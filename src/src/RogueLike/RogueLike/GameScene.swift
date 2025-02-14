//
//  GameScene.swift
//  RogueLike
//
//  Created by Starfighter Dollie on 1/22/25.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var spinnyNode : SKShapeNode?
    

    
    override func didMove(to view: SKView) {
        var newDungeon = Dungeon()
        generateDungeon(newDungeon)
        var dungeonScene = DungeonScene()
        dungeonScene.printRoomsScene(newDungeon)

        
    }
    
    func setSetting() {
        self.backgroundColor = SKColor.systemIndigo
        
        
        // Добавляем метку на сцену
        
    }
    
    func mtText() {
        let label = SKLabelNode(text: "r")
        label.color = SKColor.red
        label.fontSize = 400 // Поменяйте размер текста на более разумный
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
class DungeonScene: SKSpriteNode {
    
    let dungeonHeight = (ROOMS_PER_SIDE + 2) * SECTOR_HEIGHT
    let dungeonWidth = (ROOMS_PER_SIDE + 2) * SECTOR_WIDTH
    let floorTexture: SKTexture
    let wallTexture: SKTexture
    var dungeonScene: [[SKTexture]]
    
    init() {
        floorTexture = SKTexture(imageNamed: "floor")
        wallTexture = SKTexture(imageNamed: "wall")
        
        let floorNode = SKSpriteNode(texture: wallTexture, color: UIColor.clear, size: wallTexture.size())
        self.dungeonScene = Array(repeating: Array(repeating: floorTexture, count: dungeonWidth), count: dungeonHeight)
        
        super.init(texture: floorTexture, color: UIColor.clear, size: floorTexture.size())
        
        let wallNode = SKSpriteNode(texture: wallTexture, color: UIColor.clear, size: wallTexture.size())
               wallNode.position = CGPoint(x: 0, y: 0) // Установите позицию стены
               self.addChild(wallNode) // Добавляем стену как дочерний узел
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func printRoomsScene(_ dungeon: Dungeon) {
        let cellSize = CGSize(width: 40, height: 40)
        
        let printDungeon = PrintDungeon(dungeon)
        for i in 0..<printDungeon.dungeonGrid.count - 1 {
            for j in 0..<printDungeon.dungeonGrid.count - 1 {
                let cell = printDungeon.dungeonGrid[i][j]
                if cell == "0" || cell == "#" {
                    dungeonScene[i][j] = floorTexture
                } else if cell == "1" {
                    dungeonScene[i][j] = wallTexture
                } else {
                    continue
                }
                
                let cellNode = SKSpriteNode(texture: texture, color: .clear, size: cellSize)
                cellNode.position = CGPoint(x: CGFloat(j) * cellSize.width, y: CGFloat(i) * cellSize.height)
                self.addChild(cellNode)
            }
        }
    }
}

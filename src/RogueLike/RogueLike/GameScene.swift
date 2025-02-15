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
        
        setSetting()
    
        var newDungeon = Dungeon()
        generateDungeon(newDungeon)
        
        var dungeonScene = DungeonScene()
        dungeonScene.printRoomsScene(newDungeon)
        self.addChild(dungeonScene)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        view.addGestureRecognizer(panGesture)

        
    }
    /////////!!!!!!!!!!!!!!!!!!!!
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.view)
        
        if let dungeonScene = self.children.first as? DungeonScene {
            var newPositionX = dungeonScene.position.x + translation.x
            var newPositionY = dungeonScene.position.y - translation.y
            
            // Ограничиваем перемещение
            let minX: CGFloat = -dungeonScene.size.width / 2
            let maxX: CGFloat = self.size.width + dungeonScene.size.width / 2
            let minY: CGFloat = -dungeonScene.size.height / 2
            let maxY: CGFloat = self.size.height + dungeonScene.size.height / 2
            
            newPositionX = min(max(newPositionX, minX), maxX)
            newPositionY = min(max(newPositionY, minY), maxY)
            
            dungeonScene.position = CGPoint(x: newPositionX, y: newPositionY)
        }
        
        gesture.setTranslation(.zero, in: self.view)
    }
    
    
    
    func setSetting() {
        self.backgroundColor = SKColor.white
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
        
        self.dungeonScene = Array(repeating: Array(repeating: floorTexture, count: dungeonWidth), count: dungeonHeight)
        
        super.init(texture: nil, color: UIColor.clear, size: CGSize(width: dungeonWidth * 80, height: dungeonHeight * 80))
        
        let floorNode = SKSpriteNode(texture: wallTexture, color: UIColor.clear, size: wallTexture.size())
        let wallNode = SKSpriteNode(texture: wallTexture, color: UIColor.clear, size: wallTexture.size())
               wallNode.position = CGPoint(x: 0, y: 0) // Установите позицию стены
//               self.addChild(wallNode) // Добавляем стену как дочерний узел
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func printRoomsScene(_ dungeon: Dungeon) {
        let cellSize = CGSize(width: 50, height: 50)
        
        let offsetX: CGFloat = -1000
        let offsetY: CGFloat = -1000
        
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
                
                let cellNode = SKSpriteNode(texture: dungeonScene[i][j], color: .clear, size: cellSize)
                           // Применяем смещение к позиции узла
                           cellNode.position = CGPoint(
                               x: CGFloat(j) * cellSize.width + offsetX,
                               y: CGFloat(i) * cellSize.height + offsetY
                           )
                           self.addChild(cellNode)
            }
        }
    }
}

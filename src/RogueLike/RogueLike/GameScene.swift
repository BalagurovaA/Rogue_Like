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
        self.size = CGSize(width: 2000, height: 2000)
        setSetting()
        
    
        var newDungeon = Dungeon()
        generateDungeon(newDungeon)
        
        var dungeonScene = DungeonScene()
        dungeonScene.printRoomsScene(newDungeon)
        self.addChild(dungeonScene)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        view.addGestureRecognizer(panGesture)
//        setGhost()
        
    }
    

//    func setGhost() {
//        let offsetX: CGFloat = 0
//        let offsetY: CGFloat = 0
//        
//        var ghost: SKTexture = SKTexture(imageNamed: "ghost")
//        var knight: SKTexture = SKTexture(imageNamed: "knight")
//        let cellSize = CGSize(width: 50, height: 50) // Размер спрайта
//        
//        
//        let cellNodeGhost = SKSpriteNode(texture: ghost, color: .clear, size: cellSize)
//        let cellNodeKnight = SKSpriteNode(texture: knight, color: .clear, size: cellSize)
//        
//        cellNodeGhost.position = CGPoint(
//            x: CGFloat(cellSize.width + 1) + offsetX, // +1 для расстояния в 1 пиксель
//            y: CGFloat(cellSize.height + 1) + offsetY // +1 для расстояния в 1 пиксель
//        )
//        cellNodeKnight.position = CGPoint(
//            x: CGFloat(cellSize.width + 30) + offsetX, // +1 для расстояния в 1 пиксель
//            y: CGFloat(cellSize.height + 30) + offsetY // +1 для расстояния в 1 пиксель
//        )
//
//        self.addChild(cellNodeGhost)
//        self.addChild(cellNodeKnight)
//    }
    

    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
//        сбрасывает смещение, чтобы следующее движение начиналось с нуля
        let translation = gesture.translation(in: self.view)
        
        if let dungeonScene = self.children.first as? DungeonScene {
            var newPositionX = dungeonScene.position.x + translation.x
            var newPositionY = dungeonScene.position.y - translation.y
            
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
    let wallVertTexture: SKTexture
    let wallHorTexture: SKTexture
    var dungeonScene: [[SKTexture]]
    
    init() {
        floorTexture = SKTexture(imageNamed: "floor")
        wallVertTexture = SKTexture(imageNamed: "wallVert")
        wallHorTexture = SKTexture(imageNamed: "wallHor")
        
        self.dungeonScene = Array(repeating: Array(repeating: floorTexture, count: dungeonWidth), count: dungeonHeight)
        
        super.init(texture: nil, color: UIColor.clear, size: CGSize(width: dungeonWidth * 80, height: dungeonHeight * 80))
        
//        let floorNode = SKSpriteNode(texture: floorTexture, color: UIColor.clear, size: floorTexture.size())
//        
//        let wallVTexture = SKSpriteNode(texture: wallVertTexture, color: UIColor.clear, size: wallVertTexture.size())
//        
//        let wallHTexture = SKSpriteNode(texture: wallHorTexture, color: UIColor.clear, size: wallHorTexture.size())
        
//        wallNode.position = CGPoint(x: 0, y: 0) // Установите позицию стены
//               self.addChild(wallNode) // Добавляем стену как дочерний узел
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func printRoomsScene(_ dungeon: Dungeon) {
//        let cellSize = CGSize(width: 50, height: 50)
//        
//        let offsetX: CGFloat = 0
//        let offsetY: CGFloat = 0
//        
//        let printDungeon = PrintDungeon(dungeon)
//        
//        for i in 0..<printDungeon.dungeonGrid.count {
//            for j in 0..<printDungeon.dungeonGrid.count {
//                let cell = printDungeon.dungeonGrid[i][j]
//                var texture: SKTexture
//                
//                switch cell {
//                case "0", "#":
//                    texture = floorTexture
//                case "1":
//                    texture = wallHorTexture
//                case "2":
//                    texture = wallVertTexture
//                default:
//                    continue
//                }
//                
//                let cellNode = SKSpriteNode(texture: dungeonScene[i][j], color: .clear, size: cellSize)
//                           // Применяем смещение к позиции узла
//                           cellNode.position = CGPoint(
//                               x: CGFloat(j) * cellSize.width + offsetX,
//                               y: CGFloat(i) * cellSize.height + offsetY
//                           )
//                           self.addChild(cellNode)
//            }
//        }
//    }
    
    
    func printRoomsScene(_ dungeon: Dungeon) {
        let cellSize = CGSize(width: 10, height: 10) // Размер спрайта

        // Смещение для центрирования или начальной позиции
        let offsetX: CGFloat = -1000
        let offsetY: CGFloat = -1000

        let printDungeon = PrintDungeon(dungeon)

        for i in 0..<printDungeon.dungeonGrid.count {
            for j in 0..<printDungeon.dungeonGrid[i].count {
                let cell = printDungeon.dungeonGrid[i][j]
                var texture: SKTexture

                switch cell {
                case "0", "#":
                    texture = floorTexture
                case "1":
                    texture = wallHorTexture
                case "2":
                    texture = wallVertTexture
                default:
                    continue
                }

                // Создаем спрайт с текстурой
                let cellNode = SKSpriteNode(texture: texture, color: .clear, size: cellSize)

                // Устанавливаем позицию спрайта с учетом размера и смещения
                cellNode.position = CGPoint(
                    x: CGFloat(j) * (cellSize.width) + offsetX, // +1 для расстояния в 1 пиксель
                    y: CGFloat(i) * (cellSize.height) + offsetY // +1 для расстояния в 1 пиксель
                )


                self.addChild(cellNode)
            }
        }
    }

}

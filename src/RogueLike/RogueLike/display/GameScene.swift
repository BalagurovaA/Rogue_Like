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
    private var newDungeon = Dungeon()
    private var dungeonScene = DungeonScene()
    
    
    
    
    
    override func didMove(to view: SKView) {
        self.size = CGSize(width: 3000, height: 3000)
        
        setSetting()
        generateDungeon(newDungeon)
        dungeonScene.printRoomsScene(newDungeon)
//        map.dungeonToMap(newDungeon)
        
        self.addChild(dungeonScene)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        view.addGestureRecognizer(panGesture)
        
    }
    
    
    //метод для перемещения по карте
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

//ПОДЪЗЕМЕЛЬЕ
class DungeonScene: SKSpriteNode {
    
    let dungeonHeight = (ROOMS_PER_SIDE + 2) * SECTOR_HEIGHT
    let dungeonWidth = (ROOMS_PER_SIDE + 2) * SECTOR_WIDTH
    let floorTexture: SKTexture
    let wallVertTexture: SKTexture
    let wallHorTexture: SKTexture
    let doorVertTexture: SKTexture
    let doorHorTexture: SKTexture
    var dungeonScene: [[SKTexture]]
    
    init() {
        floorTexture = SKTexture(imageNamed: "floor")
        wallVertTexture = SKTexture(imageNamed: "wallVert")
        wallHorTexture = SKTexture(imageNamed: "wallHor")
        doorVertTexture =  SKTexture(imageNamed: "doorVert")
        doorHorTexture = SKTexture(imageNamed: "doorHor")
        
        self.dungeonScene = Array(repeating: Array(repeating: floorTexture, count: dungeonWidth), count: dungeonHeight)
        
        super.init(texture: nil, color: UIColor.clear, size: CGSize(width: dungeonWidth * 50, height: dungeonHeight * 50))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func printRoomsScene(_ dungeon: Dungeon) {
        let cellSize = CGSize(width: 50, height: 50) // Размер спрайта ОБЩИЙ
        
        // Смещение для центрирования или начальной позиции
        let offsetX: CGFloat = -CGFloat(dungeonWidth) * cellSize.width / 2
        let offsetY: CGFloat = -CGFloat(dungeonHeight) * cellSize.height / 2
        
        
        
        let map = Map()
        map.initMap()
        map.dungeonToMap(dungeon)
        for i in 0..<MAP_HEIGHT {
            for j in 0..<MAP_WIDTH {
                let cell = map.playground[i][j]
                print(map.playground[i][j])
                var texture: SKTexture
                switch cell {
                case CORRIDOR_CHAR, INNER_AREA_CHAR:
                    texture = floorTexture
                    break
                    
                case WALL_CHAR_HORISONTAL:
                    texture = wallHorTexture
                    break
                    
                case WALL_CHAR_VERTICAL:
                    texture = wallVertTexture
                    break
                    
                case DOOR:
                    texture = doorHorTexture
                    break
                    
                default:
                                    continue
                }
                let cellNode = SKSpriteNode(texture: texture, color: .clear, size: cellSize)
                cellNode.position = CGPoint(
                                   x: CGFloat(j) * (cellSize.width) + offsetX,
                                   y: CGFloat(i) * (cellSize.height) + offsetY
                               )
               
                               self.addChild(cellNode)
               
                           }
                       }
                    
                
                
                //                let cell = printDungeon.dungeonGrid[i][j]
                //                var texture: SKTexture
                ////                var size: CGSize
                //                switch cell {
                //                case "0", "#":
                //                    texture = floorTexture
                ////                    size = cellSize
                //                case "1":
                //                    texture = wallHorTexture
                ////                    size = CGSize(width: cellSize.width, height: 30)  горизонтальная стена
                //                case "2":
                //                    texture = wallVertTexture
                ////                    size = CGSize(width: 30, height: cellSize.height)
                //                case "D":
                //                    texture = doorHorTexture
                //                default:
                //                    continue
                //                }
                //
                //                let cellNode = SKSpriteNode(texture: texture, color: .clear, size: cellSize)
                //
                //
                //                cellNode.position = CGPoint(
                //                    x: CGFloat(j) * (cellSize.width) + offsetX,
                //                    y: CGFloat(i) * (cellSize.height) + offsetY
                //                )
                //
                //                self.addChild(cellNode)
                //
                //            }
                //        }
            }
            
        }
        
        
        
        //func printRoomsScene(_ dungeon: Dungeon) {
        //    let cellSize = CGSize(width: 50, height: 50) // Размер спрайта ОБЩИЙ
        //
        //    // Смещение для центрирования или начальной позиции
        //    let offsetX: CGFloat = -CGFloat(dungeonWidth) * cellSize.width / 2
        //    let offsetY: CGFloat = -CGFloat(dungeonHeight) * cellSize.height / 2
        //
        //    let printDungeon = PrintDungeon(dungeon)
        //
        //    for i in 0..<printDungeon.dungeonGrid.count {
        //        for j in 0..<printDungeon.dungeonGrid[i].count {
        //            let cell = printDungeon.dungeonGrid[i][j]
        //            var texture: SKTexture
        //            var size: CGSize
        //
        //            switch cell {
        //            case "0", "#":
        //                texture = floorTexture
        //                size = cellSize
        //            case "1":
        //                texture = wallHorTexture
        //                size = CGSize(width: cellSize.width, height: 30) // горизонтальная стена
        //            case "2":
        //                texture = wallVertTexture
        //                size = CGSize(width: 30, height: cellSize.height) // вертикальная стена
        //            default:
        //                continue
        //            }
        //
        //            let cellNode = SKSpriteNode(texture: texture, color: .clear, size: size)
        //            cellNode.position = CGPoint(
        //                x: CGFloat(j) * (cellSize.width) + offsetX,
        //                y: CGFloat(i) * (cellSize.height) + offsetY
        //            )
        //            self.addChild(cellNode)
        //        }
        //    }
        //}
        
        
        
        
        
        
        
        // ИГРОК ПОКА НЕ НУЖЕН
        //class PlayerEntityScene: SKSpriteNode  {
        //    init() {
        //        let knightTexture = SKTexture(imageNamed: "player")
        //        super.init(texture: knightTexture, color: UIColor.clear, size: knightTexture.size())
        //    }
        //
        //    required init?(coder aDecoder: NSCoder) {
        //        fatalError("init(coder:) has not been implemented")
        //    }
        //}

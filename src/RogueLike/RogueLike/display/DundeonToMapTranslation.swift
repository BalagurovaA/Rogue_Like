//
//  DundeonToMapTranslation.swift
//  RogueLike
//
//  Created by Kristofer Sartorial on 2/18/25.
//

import Foundation

class Map {
    var playground: [[Character]]
    var playerSpawn: Entity
    var exit: Entity
    var items: [Entity]
    var itemsCount: Int
    var enemies: [Entity]
    var enemiesCount: Int
    
    init() {
        playground = Array(repeating: Array(repeating: EMPTY_CHAR, count: MAP_WIDTH), count: MAP_HEIGHT)
        playerSpawn = Entity()
        exit = Entity()
        items = Array(repeating: Entity(), count: MAX_ENEMIES_TOTAL)
        itemsCount = 0
        enemies = Array(repeating: Entity(), count: MAX_ITEMS_TOTAL)
        enemiesCount = 0
        
        
    }
    /// *****************************FUNCTIONS ******************************
    
    func dungeonToMap(_ dungeon: Dungeon) {
        initMap()
        roomsToMap(dungeon)
        corridorsToMap(dungeon)
        doorsToMap(dungeon)
    }
    
    func initMap() {
        for i in 0..<MAP_HEIGHT {
            for j in 0..<MAP_WIDTH {
                playground[i][j] = OUTER_AREA_CHAR
            }
        }
        
        enemiesCount = 0
        itemsCount = 0
    }
    
    func roomsToMap(_ dungeon: Dungeon) {
        for i in 0..<dungeon.roomCount {
            guard let topRoomCorner: (x: Int, y: Int) = dungeon.sequence[i]?.topLeft else { continue }
            guard let botRoomCorner: (x: Int, y: Int) = dungeon.sequence[i]?.botRight else { continue }
            
            let topCorner = topRoomCorner
            let botCorner = botRoomCorner
            
            rectangleToMap(topCorner, botCorner)
            fillRectangle(topRoomCorner, botRoomCorner)
            
            
            for j in 0..<(dungeon.sequence[i]?.enitiesCount ?? 0) {
                
                guard let curEntity = dungeon.sequence[i]?.entities[j] else { continue }
                
                switch(curEntity.type) {
                case PLAYER:
                    playerSpawn = curEntity
                    break
                case EXIT:
                    exit = curEntity
                    break
                case ENEMY:
                    enemies[enemiesCount] = curEntity
                    enemiesCount += 1
                    break
                case ITEM:
                    items[itemsCount] = curEntity
                    break
                default:
                    break
                }
                
                playground[curEntity.position.y][curEntity.position.x] = Character(String(curEntity.symbol))
            }
        }
    }
    
    
    
    func rectangleToMap(_ top: (x: Int, y: Int), _ bot: (x: Int, y: Int)) {
        //        верх
        playground[top.y][top.x] = WALL_CHAR_HORISONTAL
        for i in (top.x + 1)...bot.x {
            playground[top.y][i] = WALL_CHAR_HORISONTAL
        }
        playground[top.y][top.x] = WALL_CHAR_HORISONTAL
        
        //        лево и право
        for i in (top.y + 1)..<bot.y {
            playground[i][top.x] = WALL_CHAR_VERTICAL
            playground[i][bot.x] = WALL_CHAR_VERTICAL
        }
        
        //        низ
        playground[bot.y][top.x] = WALL_CHAR_HORISONTAL
        for i in (top.x + 1)...bot.x {
            playground[bot.y][i] = WALL_CHAR_HORISONTAL
        }
        playground[bot.y][bot.x] = WALL_CHAR_HORISONTAL
        
    }
    
    func fillRectangle(_ top: (x: Int, y: Int), _ bot: (x: Int, y: Int) ) {
        for i in (top.y + 1)..<bot.y {
            for j in (top.x + 1)..<bot.x {
                playground[i][j] = INNER_AREA_CHAR
            }
            
        }
    }
    
    func doorsToMap(_ dungeon: Dungeon) {
        for i in 1..<ROOMS_PER_SIDE + 1 {
            for j in 1..<ROOMS_PER_SIDE + 1 {
                let room = dungeon.rooms[i][j]
                if room.sector != UNINITIALIZED {
                    for d in 0..<4 {
                        if room.doors[d].x != UNINITIALIZED && room.doors[d].y != UNINITIALIZED {
                            playground[room.doors[d].y][room.doors[d].x] = "D" // Двери
                        }
                    }
                }
            }
        }
        
    }
    
    
    
    func corridorsToMap(_ dungeon: Dungeon) {
        for i in 0..<dungeon.corridorsCount {
            switch dungeon.corridors[i].type {
                
            case LEFT_TO_RIGHT_CORRIDOR:
                drawHorisontalLine(dungeon.corridors[i].points[0], dungeon.corridors[i].points[1])
                drawVerticalLine(dungeon.corridors[i].points[1], dungeon.corridors[i].points[2])
                drawHorisontalLine(dungeon.corridors[i].points[2], dungeon.corridors[i].points[3])
                break
                
            case LEFT_TURN_CORRIDOR:
                drawVerticalLine(dungeon.corridors[i].points[0], dungeon.corridors[i].points[1])
                drawHorisontalLine(dungeon.corridors[i].points[1], dungeon.corridors[i].points[2])
                break
                
            case RIGHT_TURN_CORRIDOR:
                drawVerticalLine(dungeon.corridors[i].points[0], dungeon.corridors[i].points[1])
                drawHorisontalLine(dungeon.corridors[i].points[1], dungeon.corridors[i].points[2])
                break
                
            case TOP_TO_BOTTOM_CORRIDOR:
                drawVerticalLine(dungeon.corridors[i].points[0], dungeon.corridors[i].points[1])
                drawHorisontalLine(dungeon.corridors[i].points[1], dungeon.corridors[i].points[2])
                drawVerticalLine(dungeon.corridors[i].points[2], dungeon.corridors[i].points[3])
                break
                
            default:
                break
            }
        }
    }
    
    func drawHorisontalLine(_ firstDot: (x: Int, y: Int), _ secondDot:(x: Int, y: Int)  ) {
        let y = firstDot.y
        for x in min(firstDot.x, secondDot.x)...max(firstDot.x, secondDot.x) {
            playground[y][x] = CORRIDOR_CHAR
        }
    }
    
    func drawVerticalLine(_ firstDot: (x: Int, y: Int), _ secondDot:(x: Int, y: Int)  ) {
        let x = firstDot.x
        for y in min(firstDot.y, secondDot.y)...max(firstDot.y, secondDot.y) {
            playground[y][x] = CORRIDOR_CHAR
        }
    }
    
    
    
    
    
    
    
}

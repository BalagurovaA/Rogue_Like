//
//  DungeonGeneration.swift
//  RogueLike
//
//  Created by Kristofer Sartorial on 2/2/25.
//

import Foundation

func generateDungeon(_ dungeon: inout Dungeon) {
    initDungeon(&dungeon)
    generateSectors(&dungeon)
//    
    printSectors(&dungeon)
//
//    
    generateConnections(&dungeon)
    generateRoomsGeometry(&dungeon)
//    
//    
    printRoom(&dungeon)
//    
//    
    generateCorridorsGeometry(&dungeon)
   
}

func initDungeon(_ dungeon: inout Dungeon) {
    dungeon.roomCount = 0
    for i in 0..<ROOMS_PER_SIDE + 2 {
        for j in 0..<ROOMS_PER_SIDE + 2  {
            dungeon.rooms[i][j].sector = UNINITIALIZED
                
                for k in 0..<4  {
                    dungeon.rooms[i][j].connections[k] = nil
                    dungeon.rooms[i][j].doors[k].x = UNINITIALIZED
                    dungeon.rooms[i][j].doors[k].y = UNINITIALIZED
                }
            dungeon.rooms[i][j].enitiesCount = 0
            }
        }
    }
    
/**КОМНАТЫ**/

    //генерация секторов
func generateSectors(_ dungeon: inout Dungeon) {
    while dungeon.roomCount < 3 {
        var sectorr = 0
        for i in 1..<ROOMS_PER_SIDE + 1 {
            for j in 1..<ROOMS_PER_SIDE + 1 {
                if (dungeon.rooms[i][j].sector == -1) && (Double.random(in: 0.0..<1.0) < 0.7) {
                    dungeon.rooms[i][j].sector = sectorr
                    dungeon.rooms[i][j].grid_i = i
                    dungeon.rooms[i][j].grid_j = j
                    dungeon.sequence[dungeon.roomCount] = dungeon.rooms[i][j]
                    dungeon.roomCount += 1
                    sectorr += 1
                }
            }
        }
        dungeon.sequence.sort { room1, room2 in
            guard let leftRoom = room1, let rightRoom = room2 else { return false }
            return leftRoom.sector < rightRoom.sector
        }
    }
}
//
func printSectors(_ dungeon: inout Dungeon) {
    for i in 0..<dungeon.rooms.count {
        for j in 0..<dungeon.rooms[i].count {
            let sector = dungeon.rooms[i][j].sector
            if sector == UNINITIALIZED {
                print(" - ", terminator: "")
                } else {
                    print(String(format: "%2d ", sector), terminator: "")
                }
            }
        print()
    }
}
//
func printRoom(_ dungeon: inout Dungeon) {
    let dungeonHeight = (ROOMS_PER_SIDE + 2) * SECTOR_HEIGHT
    let dungeonWidth = (ROOMS_PER_SIDE + 2) * SECTOR_WIDTH
    
    var dungeonGrid = [[Character]](repeating: [Character](repeating: "-", count: dungeonWidth), count: dungeonHeight)
    
  
    for i in 1..<ROOMS_PER_SIDE + 1 {
        for j in 1..<ROOMS_PER_SIDE + 1 {
            let room = dungeon.rooms[i][j]
            if room.sector != UNINITIALIZED {
                // Заполняем область комнаты в матрице подземелья
                for y in room.topLeft.y...room.botRight.y {
                    for x in room.topLeft.x...room.botRight.x {
                        if y == room.topLeft.y || y == room.botRight.y || x == room.topLeft.x || x == room.botRight.x {
                            dungeonGrid[y][x] = "1"
                        } else {
                            // Иначе это внутренняя часть комнаты, ставим "0"
                            dungeonGrid[y][x] = "0"
                        }
 
  
                    }
                }
                for d in 0..<4 {
                    if room.doors[d].x != UNINITIALIZED && room.doors[d].y != UNINITIALIZED {
                        dungeonGrid[room.doors[d].y][room.doors[d].x] = "D"
                    }
                }
            }
        }
    }
    

    
    // Выводим матрицу подземелья
    for y in 0..<dungeonHeight {
        for x in 0..<dungeonWidth {
            print(dungeonGrid[y][x], terminator: "")
        }
        print()
    }
}


func generateConnections(_ dungeon: inout Dungeon) {
    generatePrimaryConnections(&dungeon)
    generateSecondaryConnections(&dungeon)
}

/**СОЕДИНЕНИЯ**/
func generatePrimaryConnections(_ dungeon: inout Dungeon) {
    for i in 1..<ROOMS_PER_SIDE + 1 {
        for j in 1..<ROOMS_PER_SIDE + 1 {
            if(dungeon.rooms[i][j].sector != UNINITIALIZED) {
                if(dungeon.rooms[i - 1][j].sector != UNINITIALIZED) {
    
                    dungeon.rooms[i][j].connections[TOP] = dungeon.rooms[i - 1][j]
                }
                
                if(dungeon.rooms[i][j + 1].sector != UNINITIALIZED) {
                    dungeon.rooms[i][j].connections[RIGHT] = dungeon.rooms[i][j + 1]
                }
                if(dungeon.rooms[i + 1][j].sector != UNINITIALIZED) {
                    dungeon.rooms[i][j].connections[BOTTOM] = dungeon.rooms[i + 1][j]
                }
                if(dungeon.rooms[i][j - 1].sector != UNINITIALIZED) {
                    dungeon.rooms[i][j].connections[LEFT] = dungeon.rooms[i][j - 1]
                }
            }
        }
    }
}

func generateSecondaryConnections(_ dungeon: inout Dungeon) {
    for i in 0..<dungeon.roomCount - 1 {
        var current: Room = dungeon.sequence[i]!
        var next: Room = dungeon.sequence[i + 1]! //????????
        
        //соединение ГОРИЗОНТАЛЬНОЕ
        if(current.grid_i == next.grid_i) && (next.connections[LEFT] == nil) {
            current.connections[RIGHT] = next
            next.connections[LEFT] = current
        }
        
        //соединение ВЕРТИКАЛЬНОЕ
        else if(current.grid_i - next.grid_i == -1 && current.connections[BOTTOM] == nil) {
//        если надо соединить О
//      О
//      | \
//      x - О
            if(current.grid_j < next.grid_j && next.connections[LEFT] == nil) {
                current.connections[BOTTOM] = next
                next.connections[LEFT] = current
            }
//      O
//   /  |
//  O - x
            else if (current.grid_j > next.grid_j && next.connections[RIGHT] == nil) {
                current.connections[BOTTOM] = next
                next.connections[RIGHT] = current
            }
        else if (current.grid_j > next.grid_j && current.connections[BOTTOM] == nil && i < dungeon.roomCount - 2) {
                current.connections[BOTTOM] = dungeon.sequence[i + 2]
                dungeon.sequence[i + 2]?.connections[RIGHT] = current
                
            }
        //соединение ЧЕРЕЗ ДВЕ КОМНАТЫ
//            O
//            |
//            O
//            |
//            O
        } else if(current.grid_i - next.grid_i == -2 && next.connections[TOP] == nil) {
            current.connections[BOTTOM] = next
            next.connections[TOP] = current
        }
    }
}

///**КОРИДОРЫ И ДВЕРИ **/
func generateRoomsGeometry(_ dungeon: inout Dungeon) {
    for i in 1..<ROOMS_PER_SIDE + 1 {
        for j in 1..<ROOMS_PER_SIDE + 1 {
            if (dungeon.rooms[i][j].sector != UNINITIALIZED) {

                generateCorners(&dungeon.rooms[i][j], (i - 1) * SECTOR_HEIGHT, (j - 1) * SECTOR_WIDTH)
//                generateDoors(&dungeon.rooms[i][j])
            }
        }
    }
}

func generateCorners(_ room: inout Room, _ offsetY: Int, _ offsetX: Int) {


    room.topLeft.y = Int.random(in: 0..<CORNER_VERT_RANGE) + offsetY + 1
    room.topLeft.x = Int.random(in: 0..<CORNER_HOR_RANGE) + offsetX + 1

    room.botRight.y = SECTOR_HEIGHT - 1 - Int.random(in: 0..<CORNER_VERT_RANGE) + offsetY - 1
    room.botRight.x = SECTOR_WIDTH - 1 - Int.random(in: 0..<CORNER_HOR_RANGE) + offsetX - 1

}

func generateDoors(_ room: inout Room) {
    
    if(room.connections[TOP] != nil) {
        room.doors[TOP].y = room.topLeft.y
        room.doors[TOP].x = Int.random(in: 0..<room.botRight.x - room.topLeft.x - 1) + room.topLeft.x + 1
    }
    if(room.connections[RIGHT] != nil) {
        room.doors[RIGHT].y = Int.random(in:0..<room.botRight.y - room.topLeft.y - 1) + room.topLeft.y + 1
        room.doors[RIGHT].x = room.botRight.x
    }
    if(room.connections[BOTTOM] != nil) {
        room.doors[BOTTOM].y = room.botRight.y
        room.doors[BOTTOM].x = Int.random(in: 0..<room.botRight.x - room.topLeft.x - 1) + room.topLeft.x + 1
    }
    if(room.connections[LEFT] != nil) {
        room.doors[LEFT].y = Int.random(in:0..<room.botRight.y - room.topLeft.y - 1) + room.topLeft.y + 1
        room.doors[LEFT].x = room.topLeft.x
    }
}



func generateCorridorsGeometry(_ dungeon: inout Dungeon) {
    for i in 1..<ROOMS_PER_SIDE + 1 {
        for j in 1..<ROOMS_PER_SIDE + 1 {

            var currentRoom = dungeon.rooms[i][j]
            
            if currentRoom.connections[RIGHT] != nil && currentRoom.connections[RIGHT]?.connections[LEFT] == currentRoom {
  
                var rightRoom = currentRoom.connections[RIGHT]!
                var corridor = dungeon.corridors[dungeon.corridorsCount]
                
                generateLeftToRightCorridor(&dungeon, &currentRoom, &rightRoom, &corridor)
                dungeon.corridors[dungeon.corridorsCount] = corridor
                dungeon.corridorsCount += 1
            }
            
            if currentRoom.connections[BOTTOM] != nil {
                var bottomRoom = currentRoom.connections[BOTTOM]!
                var corridor = dungeon.corridors[dungeon.corridorsCount]
                
//                let gridIDiff = currentRoom.grid_i - bottomRoom.grid_i
//                let gridJDiff = currentRoom.grid_j - bottomRoom.grid_j
                
                let gridIDiff = currentRoom.grid_i - bottomRoom.grid_i
                let gridJDiff = currentRoom.grid_j - bottomRoom.grid_j
                
                if gridIDiff == -1 && gridJDiff > 0 {
                    generateLeftTurnCorridor(&dungeon, &currentRoom, &bottomRoom, &corridor)
                } else if gridIDiff == -1 && gridJDiff < 0 {
                    generateRightTurnCorridor(&dungeon, &currentRoom, &bottomRoom, &corridor)
                } else {
//                    print("здесь должен был быть корридор номер комнаты текущей", currentRoom)
                    generateTopToBottomCorridor(&dungeon, &currentRoom, &bottomRoom, &corridor)
                }
                
                dungeon.corridors[dungeon.corridorsCount] = corridor
                dungeon.corridorsCount += 1
            }
        }
    }
}




 
func generateLeftToRightCorridor(_ dungeon: inout Dungeon, _ leftRoom: inout Room, _ rightRoom: inout Room, _ corridor: inout Corridor) {
    corridor.type = LEFT_TO_RIGHT_CORRIDOR
    corridor.pointsCount = 4
    corridor.points[0] = leftRoom.doors[RIGHT]
    
    var xMin = leftRoom.doors[RIGHT].x
    var xMax = rightRoom.doors[LEFT].x
    
    for i in 1..<ROOMS_PER_SIDE + 1  {
        if dungeon.rooms[i][leftRoom.grid_j].sector != UNINITIALIZED && i != leftRoom.grid_i {
            xMin = max(dungeon.rooms[i][leftRoom.grid_j].botRight.x, xMin)
        }
    }
    for i in 1..<ROOMS_PER_SIDE + 1 {
        if dungeon.rooms[i][rightRoom.grid_j].sector != UNINITIALIZED && i != rightRoom.grid_i {
            xMax = min(dungeon.rooms[i][rightRoom.grid_j].topLeft.x, xMin)
        }
    }
    
    let range = xMax - xMin - 1
    let randomValue = Int(arc4random_uniform(UInt32(range))) + 1
    let randomCenterX = randomValue + xMin
    
    let secondPoint: (x: Int, y: Int) = (randomCenterX, leftRoom.doors[RIGHT].y)
    let thirdPoint: (x: Int, y: Int) = (randomCenterX, rightRoom.doors[LEFT].y)
    
    corridor.points[1] = secondPoint
    corridor.points[2] = thirdPoint
    corridor.points[3] = rightRoom.doors[3]
}


func generateLeftTurnCorridor(_ dungeon: inout Dungeon, _ topRoom: inout Room, _ bottomLeftRoom: inout Room, _ corridor: inout Corridor) {
//         |
//       --
    corridor.type = LEFT_TURN_CORRIDOR
    corridor.pointsCount = 3
    corridor.points[0] = topRoom.doors[BOTTOM]
    
    let secondPoint: (x: Int, y: Int) = (topRoom.doors[BOTTOM].x, bottomLeftRoom.doors[RIGHT].y)
    corridor.points[1] = secondPoint
    corridor.points[2] = bottomLeftRoom.doors[RIGHT]
}


func generateRightTurnCorridor(_ dungeon: inout Dungeon, _ topRoom: inout Room, _ bottomRightRoom: inout Room, _ corridor: inout Corridor) {
    //         |
    //          --
    corridor.type = RIGHT_TURN_CORRIDOR
    corridor.pointsCount = 3
    corridor.points[0] = topRoom.doors[BOTTOM]
    
    let secondPoint: (x: Int, y: Int) = (topRoom.doors[BOTTOM].x, bottomRightRoom.doors[LEFT].y)
    corridor.points[1] = secondPoint
    corridor.points[2] = bottomRightRoom.doors[LEFT]
    
}

func generateTopToBottomCorridor(_ dungeon: inout Dungeon, _ topRoom: inout Room, _ bottomRoom: inout  Room, _ corridor: inout Corridor) {
    corridor.type = TOP_TO_BOTTOM_CORRIDOR
    corridor.pointsCount = 4
    corridor.points[0] = topRoom.doors[BOTTOM]
    
    var yMin = topRoom.doors[BOTTOM].y
    var yMax = bottomRoom.doors[TOP].y
    
    for j in 1..<ROOMS_PER_SIDE + 1 {
        if (dungeon.rooms[topRoom.grid_i][j].sector != UNINITIALIZED) {
            yMin = max(dungeon.rooms[topRoom.grid_i][j].botRight.y, yMin)
        }
    }
    for j in 1..<ROOMS_PER_SIDE + 1 {
        if (dungeon.rooms[bottomRoom.grid_i][j].sector != UNINITIALIZED) {
            yMax = min(dungeon.rooms[bottomRoom.grid_i][j].topLeft.y, yMax)
        }
    }
    
    guard yMax - yMin - 1 > 0 else {
        print("Невозможно создать коридор: недостаточно места между комнатами.")
        
        return
    }
    
    let randomCenterY = Int.random(in: 1..<(yMax - yMin)) + 1 + yMin

    let secondPoint: (x: Int, y: Int) = (topRoom.doors[BOTTOM].x, randomCenterY)
    let thirdPoint: (x: Int, y: Int) = (bottomRoom.doors[TOP].x, randomCenterY)
    
    corridor.points[1] = secondPoint
    corridor.points[2] = thirdPoint
    corridor.points[3] = bottomRoom.doors[TOP]
}






///**ТЕСТ**/
//
////func printTest() {
////    var dungeon = Dungeon()
////    initDungeon(&dungeon)
////    generateSectors(&dungeon)
////    generatePrimaryConnections(&dungeon)
////    generateSecondaryConnections(&dungeon)
////    generateRoomsGeometry(&dungeon)
////}

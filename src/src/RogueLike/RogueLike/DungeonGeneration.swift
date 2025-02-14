import Foundation

func generateDungeon(_ dungeon: Dungeon) {
    dungeon.initDungeon()
    dungeon.generateSectors()
    //    dungeon.printSectors()
    dungeon.generateConnections()
    dungeon.generateRoomsGeometry()
    
    
    dungeon.generateCorridorsGeometry()
    //    dungeon.printCorridors()
}

class Dungeon {
    var rooms: [[Room]]
    var sequence: [Room?]
    var corridors: [Corridor]
    
    var roomCount: Int
    var corridorsCount: Int
    
    init() {
        let roomPerSide: Int = 3
        let totalRooms = roomPerSide + 2
        rooms = Array(repeating: Array(repeating: Room(), count: totalRooms), count: totalRooms)
        corridors = Array(repeating: Corridor(), count: MAX_CORRIDORS_NUMBER)
        sequence = Array(repeating: nil, count: MAX_ROOMS_NUMBER)
        
        roomCount = 0
        corridorsCount = 0
    }
    /// ---------------------------------------- FUNCTIONS ----------------------------------------
    func initDungeon() {
        roomCount = 0
        for i in 0..<ROOMS_PER_SIDE + 2 {
            for j in 0..<ROOMS_PER_SIDE + 2  {
                rooms[i][j] = Room()
                rooms[i][j].sector = UNINITIALIZED
                
                for k in 0..<4  {
                    rooms[i][j].connections[k] = nil
                    rooms[i][j].doors[k].x = UNINITIALIZED
                    rooms[i][j].doors[k].y = UNINITIALIZED
                }
                rooms[i][j].enitiesCount = 0
            }
        }
        for i in 0..<MAX_CORRIDORS_NUMBER {
            corridors[i] = Corridor()
        }
    }
    
    /// ---------------------------------------- ROOMS ----------------------------------------
    func generateSectors() {
        var sectorr = 0
        while roomCount < 3 {
            for i in 1..<ROOMS_PER_SIDE + 1 {
                for j in 1..<ROOMS_PER_SIDE + 1 {
                    let randomRooms = Double.random(in: 0.0..<1.0)
                    if (rooms[i][j].sector == UNINITIALIZED) && (randomRooms < 1.0) {
                        rooms[i][j].sector = sectorr
                        rooms[i][j].grid_i = i
                        rooms[i][j].grid_j = j
                        sequence[roomCount] = rooms[i][j]
                        roomCount += 1
                        sectorr += 1
                    }
                }
            }
            sequence.sort { room1, room2 in
                guard let leftRoom = room1, let rightRoom = room2 else { return false }
                return leftRoom.sector < rightRoom.sector
            }
        }
    }
    
    /// ---------------------------------------- CONNECTIONS ----------------------------------------
    
    func generateConnections() {
        generatePrimaryConnections()
        generateSecondaryConnections()
    }
    
    func generatePrimaryConnections() {
        for i in 1..<ROOMS_PER_SIDE + 1 {
            for j in 1..<ROOMS_PER_SIDE + 1 {
                if(rooms[i][j].sector != UNINITIALIZED) {
                    if(rooms[i - 1][j].sector != UNINITIALIZED) {
                        rooms[i][j].connections[TOP] = rooms[i - 1][j]
                        
                    }
                    if(rooms[i][j + 1].sector != UNINITIALIZED) {
                        rooms[i][j].connections[RIGHT] = rooms[i][j + 1]
                        
                    }
                    if(rooms[i + 1][j].sector != UNINITIALIZED) {
                        rooms[i][j].connections[BOTTOM] = rooms[i + 1][j]
                        
                    }
                    if(rooms[i][j - 1].sector != UNINITIALIZED) {
                        rooms[i][j].connections[LEFT] = rooms[i][j - 1]
                        
                    }
                }
            }
        }
    }
    
    func generateSecondaryConnections() {
        for i in 0..<roomCount - 1 {
            let current: Room = sequence[i]!
            let next: Room = sequence[i + 1]!
            
            //соединение ГОРИЗОНТАЛЬНОЕ
            if(current.grid_i == next.grid_i) && (next.connections[LEFT] == nil)
            {
                current.connections[RIGHT] = next
                next.connections[LEFT] = current
            }
            
            //соединение ВЕРТИКАЛЬНОЕ
            else if(current.grid_i - next.grid_i == -1 && current.connections[BOTTOM] == nil)
            {
                if(current.grid_j < next.grid_j && next.connections[LEFT] == nil)
                {
                    current.connections[BOTTOM] = next
                    next.connections[LEFT] = current
                }
                else if (current.grid_j > next.grid_j && next.connections[RIGHT] == nil)
                {
                    current.connections[BOTTOM] = next
                    next.connections[RIGHT] = current
                }
                else if (current.grid_j > next.grid_j && current.connections[BOTTOM] == nil && i < roomCount - 2)
                {
                    current.connections[BOTTOM] = sequence[i + 2]
                    sequence[i + 2]?.connections[RIGHT] = current
                }
                
            } else if(current.grid_i - next.grid_i == -2 && next.connections[TOP] == nil)
            {
                current.connections[BOTTOM] = next
                next.connections[TOP] = current
            }
        }
    }
    
    /// ----------------------------------------  ROOMS AND DOORS  ----------------------------------------
    
    func generateRoomsGeometry() {
        for i in 1..<ROOMS_PER_SIDE + 1 {
            for j in 1..<ROOMS_PER_SIDE + 1 {
                if (rooms[i][j].sector != UNINITIALIZED){
                    generateCorners(rooms[i][j], (i - 1) * SECTOR_HEIGHT, (j - 1) * SECTOR_WIDTH)
                    generateDoors(rooms[i][j])
                }
            }
        }
    }
    
    func generateCorners(_ room: Room, _ offsetY: Int, _ offsetX: Int) {
        room.topLeft.y = Int.random(in: 0..<CORNER_VERT_RANGE) + offsetY + 1
        room.topLeft.x = Int.random(in: 0..<CORNER_HOR_RANGE) + offsetX + 1
        
        room.botRight.y = SECTOR_HEIGHT - 1 - Int.random(in: 0..<CORNER_VERT_RANGE) + offsetY - 1
        room.botRight.x = SECTOR_WIDTH - 1 - Int.random(in: 0..<CORNER_HOR_RANGE) + offsetX - 1
        
    }
    func generateDoors(_ room: Room) {
        
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
    
    /// ----------------------------------------  CORRIDORS  ----------------------------------------
    
    func generateCorridorsGeometry() {
        for i in 1..<ROOMS_PER_SIDE + 1 {
            for j in 1..<ROOMS_PER_SIDE + 1 {
                
                let currentRoom = rooms[i][j]
                
                if currentRoom.connections[RIGHT] != nil && currentRoom.connections[RIGHT]?.connections[LEFT]?.sector == currentRoom.sector {
                    
                    let rightRoom = currentRoom.connections[RIGHT]!
                    let corridor = corridors[corridorsCount]
                    
                    generateLeftToRightCorridor(currentRoom, rightRoom, corridor)
                    
                    //                    corridors[corridorsCount] = corridor
                    corridorsCount += 1
                }
                
                
                if currentRoom.connections[BOTTOM] != nil {
                    let bottomRoom = currentRoom.connections[BOTTOM]!
                    let corridor = corridors[corridorsCount]
                    
                    let gridIDiff = currentRoom.grid_i - bottomRoom.grid_i
                    let gridJDiff = currentRoom.grid_j - bottomRoom.grid_j
                    
                    if gridIDiff == -1 && gridJDiff > 0 {
                        generateLeftTurnCorridor(currentRoom, bottomRoom, corridor)
                    }
                    else if gridIDiff == -1 && gridJDiff < 0 {
                        generateRightTurnCorridor(currentRoom, bottomRoom, corridor)
                    } else {
                        generateTopToBottomCorridor(currentRoom, bottomRoom, corridor)
                    }
                    //                    corridors[corridorsCount] = corridor
                    corridorsCount += 1
                }
            }
        }
    }
    
    func generateLeftToRightCorridor(_ leftRoom: Room, _ rightRoom: Room, _ corridor: Corridor) {
        corridor.type = LEFT_TO_RIGHT_CORRIDOR
        corridor.pointsCount = 4
        corridor.points[0] = leftRoom.doors[RIGHT]
        
        var xMin = leftRoom.doors[RIGHT].x
        var xMax = rightRoom.doors[LEFT].x
        
        for i in 1..<ROOMS_PER_SIDE + 1 {
            if rooms[i][leftRoom.grid_j].sector != UNINITIALIZED && i != leftRoom.grid_i {
                xMin = max(rooms[i][leftRoom.grid_j].botRight.x, xMin)
            }
        }
        for i in 1..<ROOMS_PER_SIDE + 1 {
            if rooms[i][rightRoom.grid_j].sector != UNINITIALIZED && i != rightRoom.grid_i {
                xMax = min(rooms[i][rightRoom.grid_j].topLeft.x, xMax)
            }
        }
        
        guard xMax > xMin else {
            print("Error: Invalid range for corridor generation (xMax: \(xMax), xMin: \(xMin)).")
            return
        }
        
        let range = xMax - xMin - 1
        let randomCenterX = Int.random(in: 1..<range) + xMin
        
        let secondPoint = (x: randomCenterX, y: leftRoom.doors[RIGHT].y)
        let thirdPoint = (x: randomCenterX, y: rightRoom.doors[LEFT].y)
        
        corridor.points[1] = secondPoint
        corridor.points[2] = thirdPoint
        corridor.points[3] = rightRoom.doors[LEFT]
    }
    
    func generateLeftTurnCorridor(_ topRoom: Room, _ bottomLeftRoom: Room, _ corridor: Corridor) {
        
        corridor.type = LEFT_TURN_CORRIDOR
        corridor.pointsCount = 3
        corridor.points[0] = topRoom.doors[BOTTOM]
        
        let secondPoint: (x: Int, y: Int) = (topRoom.doors[BOTTOM].x, bottomLeftRoom.doors[RIGHT].y)
        corridor.points[1] = secondPoint
        corridor.points[2] = bottomLeftRoom.doors[RIGHT]
    }
    
    func generateRightTurnCorridor(_ topRoom: Room, _ bottomRightRoom: Room, _ corridor: Corridor) {
        
        corridor.type = RIGHT_TURN_CORRIDOR
        corridor.pointsCount = 3
        corridor.points[0] = topRoom.doors[BOTTOM]
        
        let secondPoint: (x: Int, y: Int) = (topRoom.doors[BOTTOM].x, bottomRightRoom.doors[LEFT].y)
        corridor.points[1] = secondPoint
        corridor.points[2] = bottomRightRoom.doors[LEFT]
    }
    
    
    func generateTopToBottomCorridor(_ topRoom: Room, _ bottomRoom: Room, _ corridor: Corridor) {
        corridor.type = TOP_TO_BOTTOM_CORRIDOR
        corridor.pointsCount = 4
        corridor.points[0] = topRoom.doors[BOTTOM]
        
        var yMin = topRoom.doors[BOTTOM].y
        var yMax = bottomRoom.doors[TOP].y
        
        for j in 1..<ROOMS_PER_SIDE + 1 {
            if (rooms[topRoom.grid_i][j].sector != UNINITIALIZED) {
                yMin = max(rooms[topRoom.grid_i][j].botRight.y, yMin)
            }
        }
        for j in 1..<ROOMS_PER_SIDE + 1 {
            if (rooms[bottomRoom.grid_i][j].sector != UNINITIALIZED) {
                yMax = min(rooms[bottomRoom.grid_i][j].topLeft.y, yMax)
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
    
    /// ----------------------------------------  PRINT  ----------------------------------------
  
    //    func printSectors() {
    //        for i in 0..<rooms.count {
    //            for j in 0..<rooms[i].count {
    //                let sector = rooms[i][j].sector
    //                if sector == UNINITIALIZED {
    //                    print(" - ", terminator: "")
    //                } else {
    //                    print(String(format: "%2d ", sector), terminator: "")
    //                }
    //            }
    //            print()
    //        }
    //    }
    //
    //    func printRoom() {
    //        let dungeonHeight = (ROOMS_PER_SIDE + 2) * SECTOR_HEIGHT
    //        let dungeonWidth = (ROOMS_PER_SIDE + 2) * SECTOR_WIDTH
    //
    //        var dungeonGrid = [[Character]](repeating: [Character](repeating: "-", count: dungeonWidth), count: dungeonHeight)
    //
    //
    //        for i in 1..<ROOMS_PER_SIDE + 1 {
    //            for j in 1..<ROOMS_PER_SIDE + 1 {
    //                let room = rooms[i][j]
    //                if room.sector != UNINITIALIZED {
    //                    for y in room.topLeft.y...room.botRight.y {
    //                        for x in room.topLeft.x...room.botRight.x {
    //                            if y == room.topLeft.y || y == room.botRight.y || x == room.topLeft.x || x == room.botRight.x {
    //                                dungeonGrid[y][x] = "1"
    //                            } else {
    //                                dungeonGrid[y][x] = "0"
    //                            }
    //                        }
    //                    }
    //                    for d in 0..<4 {
    //                        if room.doors[d].x != UNINITIALIZED && room.doors[d].y != UNINITIALIZED {
    //                            dungeonGrid[room.doors[d].y][room.doors[d].x] = "D"
    //                        }
    //                    }
    //                }
    //            }
    //        }
    //
    //
    //        for y in 0..<dungeonHeight {
    //            for x in 0..<dungeonWidth {
    //                print(dungeonGrid[y][x], terminator: "")
    //            }
    //            print()
    //        }
    //    }
    //
    //    func printCorridors() {
    //        let dungeonHeight = (ROOMS_PER_SIDE + 2) * SECTOR_HEIGHT
    //        let dungeonWidth = (ROOMS_PER_SIDE + 2) * SECTOR_WIDTH
    //
    //        var dungeonGrid = [[Character]](repeating: [Character](repeating: "-", count: dungeonWidth), count: dungeonHeight)
    //
    //        // Сначала рисуем комнаты
    //        for i in 1..<ROOMS_PER_SIDE + 1 {
    //            for j in 1..<ROOMS_PER_SIDE + 1 {
    //                let room = rooms[i][j]
    //                if room.sector != UNINITIALIZED {
    //
    //                    for y in room.topLeft.y...room.botRight.y {
    //                        for x in room.topLeft.x...room.botRight.x {
    //                            if y == room.topLeft.y || y == room.botRight.y || x == room.topLeft.x || x == room.botRight.x {
    //                                dungeonGrid[y][x] = "1" // Стены комнаты
    //                            } else {
    //                                dungeonGrid[y][x] = "0" // Внутренняя часть комнаты
    //                            }
    //                        }
    //                    }
    //
    //                    for d in 0..<4 {
    //                        if room.doors[d].x != UNINITIALIZED && room.doors[d].y != UNINITIALIZED {
    //                            dungeonGrid[room.doors[d].y][room.doors[d].x] = "D" // Двери
    //                        }
    //                    }
    //                }
    //            }
    //        }
    //
    //
    //        for corridor in corridors.prefix(corridorsCount) {
    //            for i in 0..<corridor.pointsCount - 1 {
    //                let start = corridor.points[i]
    //                let end = corridor.points[i + 1]
    //
    //                drawLine(from: start, to: end, in: &dungeonGrid)
    //            }
    //        }
    //
    //        // Вывод матрицы подземелья
    //        for y in 0..<dungeonHeight {
    //            for x in 0..<dungeonWidth {
    //                print(dungeonGrid[y][x], terminator: "")
    //            }
    //            print()
    //        }
    //    }
    //
    //    // Функция для рисования линии между двумя точками
    //    func drawLine(from start: (x: Int, y: Int), to end: (x: Int, y: Int), in grid: inout [[Character]]) {
    //        var x = start.x
    //        var y = start.y
    //
    //        let dx = abs(end.x - start.x)
    //        let dy = abs(end.y - start.y)
    //
    //        let sx = start.x < end.x ? 1 : -1
    //        let sy = start.y < end.y ? 1 : -1
    //
    //        var err = dx - dy
    //
    //        while true {
    //            // Убедимся, что не перезаписываем стены или двери
    //            if grid[y][x] == "-" {
    //                grid[y][x] = "#" // Коридор
    //            }
    //
    //            if x == end.x && y == end.y {
    //                break
    //            }
    //
    //            let e2 = 2 * err
    //            if e2 > -dy {
    //                err -= dy
    //                x += sx
    //            }
    //            if e2 < dx {
    //                err += dx
    //                y += sy
    //            }
    //        }
    //    }
    
}

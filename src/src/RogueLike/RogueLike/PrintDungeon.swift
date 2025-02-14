//
//  PrintDungeon.swift
//  RogueLike
//
//  Created by Kristofer Sartorial on 2/14/25.
//

import Foundation
class PrintDungeon {
    
    let dungeonHeight = (ROOMS_PER_SIDE + 2) * SECTOR_HEIGHT
    let dungeonWidth = (ROOMS_PER_SIDE + 2) * SECTOR_WIDTH
    var dungeonGrid: [[Character]]
    
    init(_ dungeon: Dungeon) {
        dungeonGrid = [[Character]](repeating: [Character](repeating: "-", count: dungeonWidth), count: dungeonHeight)
        
        printRooms(dungeon)
        printCorridors(dungeon)
        
        
    }
    
    func printRooms(_ dungeon: Dungeon) {
        
        for i in 1..<ROOMS_PER_SIDE + 1 {
            for j in 1..<ROOMS_PER_SIDE + 1 {
                let room = dungeon.rooms[i][j]
                if room.sector != UNINITIALIZED {
                    for y in room.topLeft.y...room.botRight.y {
                        for x in room.topLeft.x...room.botRight.x {
                            if y == room.topLeft.y || y == room.botRight.y || x == room.topLeft.x || x == room.botRight.x {
                                dungeonGrid[y][x] = "1"
                            } else {
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
    }
    
    func printCorridors(_ dungeon: Dungeon) {
        
        for i in 1..<ROOMS_PER_SIDE + 1 {
            for j in 1..<ROOMS_PER_SIDE + 1 {
                let room = dungeon.rooms[i][j]
                if room.sector != UNINITIALIZED {
                
                    for y in room.topLeft.y...room.botRight.y {
                        for x in room.topLeft.x...room.botRight.x {
                            if y == room.topLeft.y || y == room.botRight.y || x == room.topLeft.x || x == room.botRight.x {
                                dungeonGrid[y][x] = "1"
                            } else {
                                dungeonGrid[y][x] = "0"
                            }
                        }
                    }
                    printDoors(room)
                }
            }
        }
        
        for corridor in dungeon.corridors.prefix(dungeon.corridorsCount) {
            for i in 0..<corridor.pointsCount - 1 {
                let start = corridor.points[i]
                let end = corridor.points[i + 1]
                
                drawLine(from: start, to: end, in: &dungeonGrid)
            }
        }
    }
    
    func printDoors(_ room: Room) {
        
        for d in 0..<4 {
            if room.doors[d].x != UNINITIALIZED && room.doors[d].y != UNINITIALIZED {
                dungeonGrid[room.doors[d].y][room.doors[d].x] = "D" // Двери
            }
        }
    }
    
    //    // Функция для рисования линии между двумя точками
        func drawLine(from start: (x: Int, y: Int), to end: (x: Int, y: Int), in grid: inout [[Character]]) {
            var x = start.x
            var y = start.y
    
            let dx = abs(end.x - start.x)
            let dy = abs(end.y - start.y)
    
            let sx = start.x < end.x ? 1 : -1
            let sy = start.y < end.y ? 1 : -1
    
            var err = dx - dy
    
            while true {
                if grid[y][x] == "-" {
                    grid[y][x] = "#"
                }
    
                if x == end.x && y == end.y {
                    break
                }
    
                let e2 = 2 * err
                if e2 > -dy {
                    err -= dy
                    x += sx
                }
                if e2 < dx {
                    err += dx
                    y += sy
                }
            }
        }
    
    
    
}

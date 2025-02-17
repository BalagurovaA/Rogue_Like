import Foundation

/// ---------------------------------------- ROOM ----------------------------------------
class Room: Equatable {
    
    static func == (lhs: Room, rhs: Room) -> Bool {
        
        return lhs.connections == rhs.connections &&
        lhs.sector == rhs.sector &&
        lhs.topLeft == rhs.topLeft &&
        lhs.grid_i == rhs.grid_i &&
        lhs.grid_i == rhs.grid_j &&
        lhs.botRight == rhs.botRight &&
        lhs.enitiesCount == rhs.enitiesCount
        //         && lhs.doors == rhs.doors
        
    }
    
    //sector номер комнаты в сетке игр пространства
    var sector: Int
    var grid_i: Int
    var grid_j: Int
    var enitiesCount: Int
    
    var connections: [Room?]
    
    var topLeft: (x: Int, y: Int)
    var botRight: (x: Int, y: Int)
    var doors: [(x: Int, y: Int)]
    
    
    init() {
        sector = -1
        grid_i = 0
        grid_j = 0
        connections = Array(repeating: nil, count: 4)/*как комнаты будут соединяться*/ /*[TOP, RIGHT, BOTTOM, LEFT]*/
        doors = Array(repeating: (-1, -1), count: 4)
        enitiesCount = 0
        
        topLeft = (-1, -1)
        botRight = (-1, -1)
    }
}

/// ---------------------------------------- CORRIDOR ----------------------------------------
class Corridor {
    
    var type: Int
    var points: [(x: Int, y: Int)]
    var pointsCount: Int
    
    init() {
        type = UNINITIALIZED
        points = [(x: 0, y: 0), (x: 0, y: 0), (x: 0, y: 0), (x: 0, y: 0)]
        pointsCount = UNINITIALIZED
    }
    
}

/// ---------------------------------------- ENTITY ----------------------------------------
class Entity {
    var type: Int
    var symbol: Int
    var position: (x: Int, y: Int)
    
    init() {
        type = 0
        symbol = 0
        position = (x: 0, y: 0)
    }
    
}

/// ---------------------------------------- MAP ----------------------------------------
//class Map {
//    var playground: [[Int]]
//    var playerSpawn: Entity
//    var exit: Entity
//    var items: [Entity]
//    var itemsCount: Int
//    var enemies: [Entity]
//    var enemiesCount: Int
//    
//    init() {
//    playground = Array(repeating: Array(repeating: 0, count: MAP_WIDTH), count: MAP_HEIGHT)
//    playerSpawn = Entity()
//    exit = Entity()
//    items = Array(repeating: Entity(), count: MAX_ENEMIES_TOTAL)
//    itemsCount = 0
//    enemies = Array(repeating: Entity(), count: MAX_ITEMS_TOTAL)
//    enemiesCount = 0
//}
//

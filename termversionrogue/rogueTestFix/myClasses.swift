import Foundation


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

class Corridor {
    
    var type: Int
    var points: [(x: Int, y: Int)]
    var pointsCount: Int
    
    init() {
        self.type = UNINITIALIZED
        self.points = [(x: 0, y: 0), (x: 0, y: 0), (x: 0, y: 0), (x: 0, y: 0)]
        self.pointsCount = UNINITIALIZED
    }
    
}

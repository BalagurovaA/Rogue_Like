////
////  draft.swift
////  RogueLike
////
////  Created by Kristofer Sartorial on 1/26/25.
////
//
//
//
//import Foundation
//
//
//class Room {
//
//    //sector номер комнаты в сетке игр пространства
//    var sector: Int
//    var grid_i: Int
//    var grid_j: Int
//    var connections: [Int?]
//    var doors: [(x: Int, y: Int)]
//    var enitiesCount: Int
//    
//    init() {
//        self.sector = -1
//        self.grid_i = 0
//        self.grid_j = 0
//        self.connections = [0, 1, 2, 3] /*как комнаты будут объединяться*/
//        self.doors = Array(repeating: (-1, -1), count: 4)
//        self.enitiesCount = 0
//    }
//}
//
//class Dungeon {
//    var rooms: [[Room]]
//    var sequence: [Room?]
//    var coridors: [Int]
//    
//    var roomCount: Int
//    var coridorsCount: Int
//    
//    init() {
//        let roomPerSide: Int = 3
//        let totalRooms = roomPerSide + 2
//        
//        self.rooms = Array(repeating: Array(repeating: Room(), count: totalRooms), count: totalRooms)
//        self.coridors = Array(repeating: -1, count: 12)
//        self.sequence = Array(repeating: nil, count: 9)
//        
//        self.roomCount = 0
//        self.coridorsCount = 0
//    }
//
//    func initDungeon() {
//
//        for i in 0..<rooms.count {
//            for j in 0..<rooms.count {
//                rooms[i][j].sector = -1
//                
//                for k in 0..<4  {
//                    rooms[i][j].connections[k] = -1
//                    rooms[i][j].doors[k].x = -1
//                    rooms[i][j].doors[k].y = -1
//                }
//                self.rooms[i][j].enitiesCount = 0
//            }
//        }
//    }
//
//  //генерация секторов
//    func generateSectors() {
//        while roomCount < 3 {
//            var sectorr = 0
//            for i in 1..<ROOMS_PER_SIDE + 1 {
//                for j in 1..<ROOMS_PER_SIDE + 1 {
//                    if (rooms[i][j].sector == -1) && (Double.random(in: 0.0..<1.0) < 0.5) {
//                        rooms[i][j].sector = sectorr
//                        rooms[i][j].grid_i = i
//                        rooms[i][j].grid_j = j
//                        sequence[roomCount] = rooms[i][j]
//                        roomCount += 1
//                        sectorr += 1
//                    }
//                }
//            }
//            sequence.sort { room1, room2 in
//                guard let leftRoom = room1, let rightRoom = room2 else { return false }
//                return leftRoom.sector < rightRoom.sector
//            }
//        }
//    }
//
//    func printSectors() {
//            for i in 0..<rooms.count {
//                for j in 0..<rooms[i].count {
//                    // Выводим сектор комнаты, выравнивая по ширине
//                    let sector = rooms[i][j].sector
//                    if sector == -1{
//                        print(" - ", terminator: "") // Если сектор не инициализирован
//                    } else {
//                        print(String(format: "%2d ", sector), terminator: "") // Форматируем вывод
//                    }
//                }
//                print() // Переход на новую строку после каждой строки комнат
//            }
//        }
//}
//
//// для проверки 
//func printTest() {
//    var dungeon = Dungeon()
//    dungeon.initDungeon()
//    dungeon.generateSectors()
//    dungeon.printSectors()
//}

//
//  Constants.swift
//  RogueLike
//
//  Created by Kristofer Sartorial on 1/26/25.
//
import Foundation

let UNINITIALIZED = -1

let CONNECTED = 0
let NOT_CONNECTED = 1

let MAP_HEIGHT =  30
let MAP_WIDTH  =  90

let ROOMS_PER_SIDE =  3

let MAX_ROOMS_NUMBER = ROOMS_PER_SIDE * ROOMS_PER_SIDE
let MAX_CORRIDORS_NUMBER = 12

let SECTOR_HEIGHT = MAP_HEIGHT / ROOMS_PER_SIDE
let SECTOR_WIDTH = MAP_WIDTH / ROOMS_PER_SIDE

let CORNER_VERT_RANGE = (SECTOR_HEIGHT - 6) / 2
let CORNER_HOR_RANGE = (SECTOR_WIDTH - 6) / 2

let ROOM_CHANCE = 0.5
let SPAWN_SET_CHANCE = 0.5

let MAX_ENEMIES_PER_ROOM = 5
let MAX_ITEMS_PER_ROOM = 3
let MAX_ENTITIES_PER_ROOM = MAX_ENEMIES_PER_ROOM + MAX_ITEMS_PER_ROOM + 2
let MAX_ENEMIES_TOTAL = MAX_ENEMIES_PER_ROOM * ROOMS_PER_SIDE * ROOMS_PER_SIDE
let MAX_ITEMS_TOTAL = MAX_ITEMS_PER_ROOM * ROOMS_PER_SIDE * ROOMS_PER_SIDE
let MAX_ENTITIES_TOTAL = MAX_ENEMIES_TOTAL + MAX_ITEMS_TOTAL + 2
let ENEMY_POOL_LEN = 26
let ITEM_POOL_LEN = 5

let TOP = 0
let RIGHT = 1
let BOTTOM = 2
let LEFT = 3

let LEFT_TO_RIGHT_CORRIDOR = 0
let LEFT_TURN_CORRIDOR = 1
let RIGHT_TURN_CORRIDOR = 2
let TOP_TO_BOTTOM_CORRIDOR = 3

let UNOCCUPIED = 0
let OCCUPIED = 1

let PLAYER = 0
let EXIT = 1
let ENEMY = 2
let ITEM = 3

let IS_OUTER = 0
let IS_INNER = 1
let IS_WALL = 2

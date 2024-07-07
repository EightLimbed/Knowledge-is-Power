extends Resource

class_name Level

#enemies to pick from
@export var possible_enemies : Array[Enemy]
#how many enemies room can have
@export var room_difficulty : int

#tileset
@export var tiles : TileSet

#generation options
@export var rooms : int
@export var branch_chance : int

extends TileMap

var tiles : Array

# Called when the node enters the scene tree for the first time.
func _ready():
	for tile in get_used_cells(0):
		tiles.append(tile)
	print(tiles)

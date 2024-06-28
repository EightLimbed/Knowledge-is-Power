extends TileMap

var random = RandomNumberGenerator.new()
var floor
var walls
var room_centers

func _ready():
	#gets important values
	floor = $Artist.floor
	walls = $Artist.walls
	room_centers = $Artist.room_centers
	
	render_dungeon()

#remember to use multiple tilesets
func render_dungeon():
	#fills in wall tiles
	for i in walls.size():
		set_cell(0, walls[i], 0, Vector2i(0,0), 0)
	#fills in floor tiles
	#in future, will pick from a floor tileset
	for i in floor.size():
		set_cell(0, floor[i], 0, Vector2i(1,0), 0)
		
	
	#no enemies or chests can spawn at start
	#places something at start, like designs
	set_cell(0, room_centers[0], 0, Vector2i(0,0), 0)

	#places something at end, like portal
	set_cell(0, room_centers[room_centers.size()-1], 0, Vector2i(0,0), 0)

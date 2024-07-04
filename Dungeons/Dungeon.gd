extends TileMap

var random = RandomNumberGenerator.new()
var ground
var walls
var room_centers
signal next_level()

func _ready():
	
	new_level()

func _on_portal_trigger_body_entered(body):
	if body.name == "Player":
		new_level()

func new_level():
	var color_change = randf_range(0.4,1.6)
	modulate.r = color_change
	modulate.g = color_change
	modulate.b = color_change
	clear_layer(0)
	clear_layer(1)
	#gets dungeon design
	$Designer.design_dungeon(Vector2(0,0), 10, 1)
	#gets important values
	ground = $Designer.ground
	walls = $Designer.walls
	room_centers = $Designer.room_centers
	#renders dungeon from design
	render_dungeon()
	next_level.emit()

#remember to use multiple tilesets
func render_dungeon():
	#fills in wall tiles
	for tile in walls:
		set_cell(1, tile+Vector2(-1,-1), 0, Vector2i(0,0), 0)
		set_cell(0, tile, 0, Vector2i(1,0), 0)
	#fills in floor tiles
	#in future, will pick from a floor tileset
	for tile in ground:
		set_cell(0, tile, 0, Vector2i(1,0), 0)
		set_cell(1, tile+Vector2(-1,-1), -1)
	
	for tile in room_centers:
		pass
	#no enemies or chests can spawn at start
	#places portal frame at start
	set_cell(1, room_centers[0]+Vector2(-3,-3), 1, Vector2i(0,0), 0)

	#places portal at end
	set_cell(1, room_centers[room_centers.size()-1]+Vector2(-3,-3), 1, Vector2i(0,0), 0)
	$PortalTrigger.position = map_to_local(room_centers[room_centers.size()-1])

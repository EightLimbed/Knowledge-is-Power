extends TileMap

#setup
var random = RandomNumberGenerator.new()
var ground : Array
var walls : Array
var room_centers : Array
signal next_level()

#enemies/levels
var main
var levels = preload("res://Dungeons/Levels/Levels.tres")
var current_level : int = -1
var base_enemy = preload("res://Enemies/Enemy.tscn")

func _ready():
	main = get_tree().get_root().get_node("Game").get_node("EnemiesContainer")
	new_level()

func _on_portal_trigger_body_entered(body):
	if body.name == "Player":
		new_level()

func new_level():
	current_level += 1
	var color_change = random.randf_range(0.4,1.6)
	modulate.r = color_change
	modulate.g = color_change
	modulate.b = color_change
	clear_layer(0)
	clear_layer(1)
	#gets dungeon design
	$Designer.design_dungeon(Vector2(0,0), levels.levels[current_level].rooms, levels.levels[current_level].branch_chance)
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

	#spawns enemies around room centers
	for i in room_centers.size()-2:
		spawn_enemies(room_centers[i+1], levels.levels[current_level])

	#places portal frame at start
	set_cell(1, room_centers[0]+Vector2(-3,-3), 1, Vector2i(0,0), 0)

	#places portal at end
	set_cell(1, room_centers[room_centers.size()-1]+Vector2(-3,-3), 1, Vector2i(0,0), 0)
	$PortalTrigger.position = map_to_local(room_centers[room_centers.size()-1])

#spawns enemies based on level
func spawn_enemies(current_room, level):
	var difficulty = level.room_difficulty
	#goes through enemies and pulls weighted difficulty
	while difficulty > 0:
		var enemy = level.possible_enemies[random.randi_range(0, level.possible_enemies.size()-1)]
		var instance = base_enemy.instantiate()
		var spawn_offset = Vector2(random.randi_range(-13,13), random.randi_range(-13,13))
		instance.profile = enemy
		instance.spawn_pos = map_to_local(current_room+spawn_offset)
		main.add_child.call_deferred(instance)
		difficulty -= enemy.difficulty

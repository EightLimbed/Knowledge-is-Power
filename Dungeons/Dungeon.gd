extends TileMap

#setup
var random = RandomNumberGenerator.new()
var ground : Array
var walls : Array
var room_centers : Array
@export var enemies : Array[Enemy]
var enemy_count : int = 0
signal next_level()

#enemies/levels
var enemy_container
var current_level : int = -1
var base_enemy = preload("res://Enemies/Enemy.tscn")

#pickup
var pickup_container
var pickup = preload("res://Pickups/ItemPickup.tscn")

func _ready():
	enemy_container = get_tree().get_root().get_node("Game").get_node("EnemiesContainer")
	pickup_container = get_tree().get_root().get_node("Game").get_node("PickupsContainer")
	new_level()

func _process(_delta) -> void:
	var count = enemy_container.get_child_count()
	var active = (enemy_count-count >= enemy_count/2)
	$PortalTrigger/PortalParticles.visible = active
	$PortalTrigger/Label.visible = !active
	$PortalTrigger/Label.text = str(enemy_count-count) + "/" + str(enemy_count/2)
	$PortalTrigger.monitoring = active

func _on_portal_trigger_body_entered(body):
	if body.name == "Player":
		new_level()

func new_level():
	enemy_count = 0
	current_level += 1
	var color_change = random.randf_range(0.4,1.6)
	modulate.r = color_change
	modulate.g = color_change
	modulate.b = color_change
	clear_layer(0)
	clear_layer(1)
	#gets dungeon design
	$Designer.design_dungeon(Vector2(0,0), min(current_level*2+4,10), 1)
	#gets important values
	ground = $Designer.ground
	walls = $Designer.walls
	room_centers = $Designer.room_centers
	#renders dungeon from design
	setup_dungeon()
	next_level.emit()

#remember to use multiple tilesets
func setup_dungeon():
	#fills in wall tiles
	for tile in walls:
		set_cell(1, tile+Vector2(-1,-1), 0, Vector2i(0,0), 0)
		set_cell(0, tile, 0, Vector2i(1,0), 0)

	#fills in floor tiles
	#in future, will pick from a floor tileset
	for tile in ground:
		set_cell(0, tile, 0, Vector2i(1,0), 0)
		set_cell(1, tile + Vector2(-1,-1), -1)

	#spawns enemies around room centers
	for i in room_centers.size()-2:
		spawn_enemies(room_centers[i+1], random.randi_range(current_level*2+5, current_level*2+10))

	#spawns random powerup(s) (always base grimoire on level 1)
	var powerup_count = min((current_level)*3,10)
	for i in powerup_count:
		var instance = pickup.instantiate()
		instance.position = Vector2(cos(2*i*PI/powerup_count), sin(2*i*PI/powerup_count))*128.0
		pickup_container.add_child.call_deferred(instance)
		instance.generate.call_deferred()

	#places portal frame at start
	set_cell(1, room_centers[0]+Vector2(-3,-3), 1, Vector2i(0,0), 0)

	#places portal at end
	set_cell(1, room_centers[room_centers.size()-1]+Vector2(-3,-3), 1, Vector2i(0,0), 0)
	$PortalTrigger.position = map_to_local(room_centers[room_centers.size()-1])

#spawns enemies based on level
func spawn_enemies(current_room, difficulty):
	#goes through enemies and pulls weighted difficulty
	while difficulty > 0:
		var enemy = enemies[random.randi_range(0,min(current_level,enemies.size()-1))]
		var instance = base_enemy.instantiate()
		var spawn_offset = Vector2(random.randi_range(-14,14), random.randi_range(-14,14))
		instance.profile = enemy
		instance.spawn_pos = map_to_local(current_room+spawn_offset)
		enemy_container.add_child.call_deferred(instance)
		difficulty -= enemy.difficulty
		enemy_count += 1

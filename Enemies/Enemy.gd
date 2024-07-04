extends CharacterBody2D

var agro : bool
var hover : bool
var attacking : bool
var input : Vector2

#setup
var random = RandomNumberGenerator.new()
var profile = Enemy
var projectile
var main
var player

func _ready():
	main = get_tree().get_root().get_node("Game")
	profile = load("res://Enemies/Shooter/Shooter.tres")
	projectile = load("res://Enemies/Projectile.tscn")
	player = get_tree().get_root().get_node("Player")

func _physics_process(delta):
	if agro:
		to_player()
		if hover:
			velocity = input.normalized()*profile.speed*delta*Vector2(1,0.5)
		else:
			velocity = -input.normalized()*profile.speed*delta*Vector2(1,0.5)
		move_and_slide()

func to_player():
	if player.position.x > position.x + 20:
		input.x = -1
	if player.position.x < position.x - 20:
		input.x = 1
	if player.position.y > position.y + 20:
		input.y = -1
	if player.position.y < position.y - 20:
		input.y = 1

func shoot():
	#start for spread
	var spread_start = -profile.multishot/2
	#shoots bullets
	for i in profile.multishot:
		#creates projectile
		var instance = projectile.instantiate()
		#sets rotation, modified by spread
		instance.rot = rotation + i*profile.spread+spread_start
		#sets starting transfom
		instance.spawn_pos = global_position
		instance.spawn_rot = rotation
		#sets projectile stats and texture
		instance.texture = profile.projectile_texture
		instance.lifetime = profile.proj_lifetime
		instance.speed = profile.proj_speed
		instance.damage = profile.damage
		#adds child
		main.add_child.call_deferred(instance)


#behavior
func _on_hover_distance_area_entered(area):
	hover = false

func _on_hover_distance_area_exited(area):
	hover = true

func _on_attack_distance_area_entered(area):
	attacking = true

func _on_attack_distance_area_exited(area):
	attacking = false

func _on_aggro_distance_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	agro = true

func _on_aggro_distance_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	agro = false

extends CharacterBody2D

var agro : bool
var hover : bool
var hover_ease : bool
var attacking : bool
var input : Vector2

#for naming bullets properly
var bullets_total : int = 0

#setup
var random = RandomNumberGenerator.new()
@onready var profile = Enemy
var projectile = preload("res://Enemies/Projectile.tscn")
var main
@onready var player = $"../Player"
@onready var texture = $EnemyTexture
@onready var attack_speed = $AttackTimer

func _ready():
	main = get_tree().get_root().get_node("Game")
	profile = load("res://Enemies/Shooter/Shooter.tres")
	texture.sprite_frames = profile.sprite_frames
	attack_speed.wait_time = profile.attack_speed

func _physics_process(delta):
	if agro:
		input_to_player()
		direction_texture()
		if hover:
			velocity = -input.normalized()*profile.speed*delta*Vector2(0.5,0.25)
		else:
			velocity = input.normalized()*profile.speed*delta*Vector2(1,0.5)
		move_and_slide()

func input_to_player():
	#gets inputs
	if player.global_position.x > global_position.x + 96:
		input.x = 1
	if player.global_position.x < global_position.x - 96:
		input.x = -1
	if player.global_position.y > global_position.y + 48:
		input.y = 1
	if player.global_position.y < global_position.y - 48:
		input.y = -1

	#makes enemy not move on an axis, if it is close to the player on it
	if player.global_position.x < global_position.x + 48 and player.global_position.x > global_position.x - 48:
		input.x = 0
	if player.global_position.y < global_position.y + 24 and player.global_position.y > global_position.y - 24:
		input.y = 0

#shoots bullets with stats from profile
func shoot():
	var spread_offset = deg_to_rad(profile.spread)*(profile.multishot-1)/2
	for i in profile.multishot:
		#start for spread
		var instance = projectile.instantiate()
		#sets starting transfom
		instance.spawn_pos = global_position
		#sets rotation, modified by spread
		instance.rot = global_position.angle_to_point(player.global_position) + i*deg_to_rad(profile.spread) - spread_offset
		#sets projectile stats and texture
		instance.texture = profile.projectile_texture
		instance.lifetime = profile.proj_lifetime
		instance.speed = profile.proj_speed
		instance.damage = profile.damage
		instance.name = "Projectile"+str(bullets_total)
		#adds child
		main.add_child.call_deferred(instance)
		bullets_total += 1

#directional costumes
func direction_texture():
	#0
	if input == Vector2(0,1):
		texture.frame = 0
	#45
	elif input == Vector2(-1,1):
		texture.frame = 1
	#90
	elif input == Vector2(-1,0):
		texture.frame = 2
	#135
	elif input == Vector2(-1,-1):
		texture.frame = 3
	#180
	elif input == Vector2(0,-1):
		texture.frame = 4
	#225
	elif input == Vector2(1,-1):
		texture.frame = 5
	#270
	elif input == Vector2(1,0):
		texture.frame = 6
	#315
	elif input == Vector2(1,1):
		texture.frame = 7

func _on_aggro_distance_body_entered(body):
	agro = true


func _on_aggro_distance_body_exited(body):
	agro = false


func _on_attack_distance_body_entered(body):
	attacking = true


func _on_attack_distance_body_exited(body):
	attacking = false


func _on_hover_distance_body_entered(body):
	hover = true


func _on_hover_distance_body_exited(body):
	hover = false

func _on_attack_timer_timeout():
	if attacking:
		shoot()
	attack_speed.start()

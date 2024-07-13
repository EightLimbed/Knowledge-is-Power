extends CharacterBody2D

#behavior
var agro : bool
var hover : bool
var hover_ease : bool
var attacking : bool
var input : Vector2
var hit : float

#for naming bullets properly
@onready var projectile_emitter = $ProjectileEmitter

#blood splatter
var blood_splatter = preload("res://Communal/Afterimages/Bloodstains/Bloodstains.tscn")
var afterimages_main

#setup
var health
@export var spawn_pos : Vector2
var random = RandomNumberGenerator.new()
@export var profile : Enemy
var projectiles_main
var player
@onready var texture = $EnemyTexture
@onready var attack_speed = $AttackTimer
@onready var health_bar = $HealthBar

func _ready():
	projectiles_main = get_tree().get_root().get_node("Game").get_node("ProjectilesContainer")
	afterimages_main = get_tree().get_root().get_node("Game").get_node("AfterimagesContainer")
	player = get_tree().get_root().get_node("Game").get_node("Player")
	#gets things from profile
	texture.sprite_frames = profile.sprite_frames
	attack_speed.wait_time = profile.attack_speed
	health = profile.max_health
	#goes to spawn
	global_position = spawn_pos

func _physics_process(delta):
	#updates health and does immunity frames
	health_bar.update(0, health, profile.max_health)
	hit -= delta

	#behavior
	if agro:
		visible = true
		input_to_player()
		direction_texture()
		if not hover and not attacking:
			velocity = input.normalized()*profile.speed*delta*Vector2(1,0.5)
		elif hover:
			velocity = -input.normalized()*profile.speed*delta*Vector2(0.5,0.25)
		move_and_slide()
	else:
		visible = false

#gets enemy pointing towards player
func input_to_player():
	input = (player.position-position).normalized()

#directional costumes
func direction_texture():
	#0
	if round(input) == Vector2(0,1):
		texture.frame = 0
	#45
	elif round(input) == Vector2(-1,1):
		texture.frame = 1
	#90
	elif round(input) == Vector2(-1,0):
		texture.frame = 2
	#135
	elif round(input) == Vector2(-1,-1):
		texture.frame = 3
	#180
	elif round(input) == Vector2(0,-1):
		texture.frame = 4
	#225
	elif round(input) == Vector2(1,-1):
		texture.frame = 5
	#270
	elif round(input) == Vector2(1,0):
		texture.frame = 6
	#315
	elif round(input) == Vector2(1,1):
		texture.frame = 7

#behavior signals
func _on_aggro_distance_body_entered(_body):
	agro = true


func _on_aggro_distance_body_exited(_body):
	agro = false


func _on_attack_distance_body_entered(_body):
	attacking = true


func _on_attack_distance_body_exited(_body):
	attacking = false


func _on_hover_distance_body_entered(_body):
	hover = true


func _on_hover_distance_body_exited(_body):
	hover = false

#attacking
func _on_attack_timer_timeout():
	if attacking:
		#shoot(texture, spawn, target, multishot, spread, lifetime, speed, damage, piercing)
		projectile_emitter.shoot(profile.projectile_texture, "EProj", global_position, player.global_position, profile.multishot, profile.spread, profile.projectile_lifetime, profile.projectile_speed, profile.damage)
	attack_speed.start()

#takes damage
func _on_damage_hitbox_body_entered(body):
	if body.name.begins_with("PProj") and hit <= 0:
		take_damage(body.damage)

func take_damage(damage):
	health -= damage
	hit = 0.05
	splatter()
	death()

#kills enemy when health is below zero
func death():
	if health <= 0:
		#add death animation or something
		queue_free()

func splatter():
	var instance = blood_splatter.instantiate()
	instance.global_position = global_position
	afterimages_main.add_child.call_deferred(instance)

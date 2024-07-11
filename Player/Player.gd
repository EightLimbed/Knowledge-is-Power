extends CharacterBody2D

var texture

#movement
var input = Vector2(0,0)
var speed = 20000
var dash_speed = 5
var dash_length : float = 0.1
var dash_time : float = 0
@export var dash_charge : float = 0
@export var dash_cooldown : float = 250

#projectiles
var bullets_total : int = 0
var projectile = preload("res://Enemies/Projectile.tscn")
var main

#resources
@export var health : int = 100
@export var max_health : int = 100
var hit : float = 0


func _ready():
	main = get_tree().get_root().get_node("Game").get_node("ProjectilesContainer")
	texture = $PlayerTexture

func _physics_process(delta):

	#gets direction of input
	input.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	input.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))

	#moves
	velocity = input.normalized()*speed*delta*Vector2(1,0.5)

	#gets dash
	dash(delta)

	#shooting (temporary)
	if Input.is_action_just_pressed("Mouse"):
		shoot()

	#deals with immunity frames
	hit -= delta

	#moves and displays textures
	direction_texture(input)
	move_and_slide()

#directional costumes
func direction_texture(dir: Vector2):
	#0
	if dir == Vector2(0,1):
		texture.frame = 0
	#45
	elif dir == Vector2(-1,1):
		texture.frame = 1
	#90
	elif dir == Vector2(-1,0):
		texture.frame = 2
	#135
	elif dir == Vector2(-1,-1):
		texture.frame = 3
	#180
	elif dir == Vector2(0,-1):
		texture.frame = 4
	#225
	elif dir == Vector2(1,-1):
		texture.frame = 5
	#270
	elif dir == Vector2(1,0):
		texture.frame = 6
	#315
	elif dir == Vector2(1,1):
		texture.frame = 7

#takes damage from projectiles
func _on_damage_hitbox_body_entered(body):
	if body.name.begins_with("EProj") and hit <= 0:
		health -= body.damage
		$BloodSplatter.emitting = true
		hit = 0.1

#handles dash
func dash(delta):
	#starts dash if cooldown is over
	if Input.is_action_just_pressed("ui_accept") and dash_charge >= dash_cooldown:
		dash_time = dash_length
		dash_charge = 0

	#does dashing, or basic movement
	if dash_time > 0:
		#dashing gives immunity frames
		hit = 0.2
		#dash time runs out
		dash_time -= delta
		velocity = dash_speed*input.normalized()*speed*delta*Vector2(1,0.5)
	else:
		dash_charge += delta*500

#shoots bullets
func shoot():
	var instance = projectile.instantiate()
	#sets starting transfom
	instance.spawn_pos = global_position
	#sets rotation, modified by spread
	instance.rot = global_position.angle_to_point(get_global_mouse_position())
	#sets projectile stats and texture
	instance.lifetime = 2
	instance.speed = 40000
	instance.damage = 10
	instance.name = "PProj"+str(bullets_total)
	#adds child
	main.add_child.call_deferred(instance)
	bullets_total += 1

extends CharacterBody2D

@onready var texture = $PlayerTexture

#movement
var input = Vector2(0,0)
var speed = 20000
var dash_speed = 5
var dash_length : float = 0.1
var dash_time : float = 0.0
@export var dash_charge : float = 0.0
@export var dash_cooldown : float = 400
@onready var game = get_tree().get_root().get_node("Game")

#projectiles
var bullets_total : int = 0
var projectile = preload("res://Communal/Projectiles/Projectile.tscn")
@onready var projectiles_main = game.get_node("ProjectilesContainer")

#blood splatter
var blood_splatter = preload("res://Communal/Afterimages/Bloodstains/Bloodstains.tscn")
@onready var afterimages_main = game.get_node("AfterimagesContainer")

#stats
@export var health : int = 100
@export var max_health : int = 100
@export var mana : float = 200
@export var max_mana : int = 500
@export var mana_regen : int = 50
var hit : float = 0
@onready var grimoires_container = $GrimoiresContainer

func _ready():
	pattern_children()

func _physics_process(delta):
	#RenderingServer.global_shader_parameter_set("player_pos", position)
	#gets direction of input
	input.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	input.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	input += $TouchScreenButton.input
	#moves
	velocity = input.normalized()*speed*delta*Vector2(1,0.5)

	#gets dash
	dash(delta)

	#regenerates mana
	if mana <= max_mana:
		mana += delta*mana_regen
	else:
		mana = max_mana

	#shooting (temporary)
	if Input.is_action_just_pressed("Mouse"):
		pass

	#deals with immunity frames
	hit -= delta
	if hit > 0:
		texture.self_modulate = "ffffff64"
	else:
		texture.self_modulate = "ffffff"

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
		body.pierce -= 1
		health -= body.damage
		if health <= 0:
			die()
		texture.self_modulate.a = 100
		splatter()
		hit = 0.5

#handles dash
func dash(delta):
	#starts dash if cooldown is over
	if Input.is_action_just_pressed("ui_accept") and dash_charge >= dash_cooldown:
		dash_time = dash_length
		dash_charge = 0

	#does dashing, or basic movement
	if dash_time > 0:
		#dashing gives immunity frames
		hit = 0.11
		#dash time runs out
		dash_time -= delta
		velocity = dash_speed*input.normalized()*speed*delta*Vector2(1,0.5)
	else:
		dash_charge += delta*500

#makes player bleed
func splatter():
	var instance = blood_splatter.instantiate()
	instance.global_position = global_position
	afterimages_main.add_child.call_deferred(instance)

func die():
	game.player_death()

#makes grimoires look good
func stagger_grimoires():
	var grimoires = grimoires_container.get_children()
	#staggers grimoires
	var increase := 178.89/grimoires.size()
	for f in grimoires.size():
		grimoires[f].path_offset = increase*(f)

func pattern_children():
	var children = grimoires_container.get_children()
	var groups = []
	for child in children:
		while child.type > groups.size()-1:
			groups.append([])
		groups[child.type].append(child)
	for group in groups:
		var gsize = group.size()
		for i in gsize:
			group[i].path_offset = float(i)*178.89/float(gsize)
			group[i].path_prog = 0.0

func add_grimoire(grimoire : PackedScene):
	var instance = grimoire.instantiate()
	grimoires_container.add_child.call_deferred(instance)
	pattern_children.call_deferred()

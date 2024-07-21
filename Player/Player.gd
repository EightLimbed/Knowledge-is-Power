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
var projectile = preload("res://Communal/Projectiles/Projectile.tscn")
var projectiles_main

#blood splatter
var blood_splatter = preload("res://Communal/Afterimages/Bloodstains/Bloodstains.tscn")
var afterimages_main

#stats
@export var health : int = 100
@export var max_health : int = 100
@export var mana : float = 200
@export var max_mana : int = 200
@export var mana_regen : int = 50
var hit : float = 0
@onready var grimoires_container = $GrimoiresContainer

func _ready():
	pattern_children(grimoires_container)
	#projectiles
	projectiles_main = get_tree().get_root().get_node("Game").get_node("ProjectilesContainer")
	#bloodstains
	afterimages_main = get_tree().get_root().get_node("Game").get_node("AfterimagesContainer")
	#texture
	texture = $PlayerTexture
	#staggers grimoires, so they dont overlap
	stagger_grimoires()

func _physics_process(delta):
	#gets direction of input
	input.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	input.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))

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
		health -= body.damage
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

#makes grimoires look good
func stagger_grimoires():
	var grimoires = grimoires_container.get_children()
	#staggers grimoires
	var increase := 178.88/grimoires.size()-(1/178.88/grimoires.size())
	for f in grimoires.size():
		grimoires[f].path_offset = increase*(f)-(1/178.88/grimoires.size())


#temporary until inventory
func pattern_children(parent: Node):
	#gets children values
	var alphabet : String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
	var sorted_children := parent.get_children()

	#groups children by type
	sorted_children.sort_custom(
	func(a: Node, b: Node): return a.name.naturalnocasecmp_to(b.name) > 0)

	#groups children by number, and staggers type
	sorted_children.sort_custom(
	func(a: Node, b: Node): return a.name.lstrip(alphabet).naturalnocasecmp_to(b.name.lstrip(alphabet)) > 0)

	#sorts children
	for node in sorted_children:
		parent.move_child(node, 0)
	

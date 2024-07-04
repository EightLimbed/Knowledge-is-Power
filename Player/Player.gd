extends CharacterBody2D

var texture

#movement
var input = Vector2(0,0)
var speed = 20000
var dash_speed = 5
var dash_length : float = 0.1
var dash_time : float = 0
@export var dash : float = 0
@export var dash_cooldown : float = 250

#resources
@export var health : int = 99
@export var max_health : int = 100

func _ready():
	texture = $PlayerTexture

func _physics_process(delta):
	#gets direction of input
	input.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	input.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	
	#starts dash if cooldown is over
	if Input.is_action_just_pressed("ui_accept") and input and dash >= dash_cooldown:
		dash_time = dash_length
		dash = 0

	#does dashing, or basic movement
	if dash_time > 0:
		dash_time -= delta
		velocity = dash_speed*input.normalized()*speed*delta*Vector2(1,0.5)
	else:
		dash += delta*500
		velocity = input.normalized()*speed*delta*Vector2(1,0.5)
	direction_texture(input)
	move_and_slide()


#temporary, before animations
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


func _on_area_2d_area_entered(body):
	if body.name == "Projectile":
		health -= body.damage

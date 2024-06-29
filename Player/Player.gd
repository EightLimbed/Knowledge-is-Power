extends CharacterBody2D


var speed = 20000

var input = Vector2(0,0)
var position_cartesian = Vector2(0,0)
var player

func _ready():
	player = $PlayerTexture

func _physics_process(delta):
	input.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	input.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	velocity = input.normalized()*speed*delta*Vector2(1,0.5)
	direction_texture(input)
	move_and_slide()

#temporary, before animations
func direction_texture(input: Vector2):
	#0
	if input == Vector2(0,1):
		player.frame = 0
	#45
	elif input == Vector2(-1,1):
		player.frame = 1
	#90
	elif input == Vector2(-1,0):
		player.frame = 2
	#135
	elif input == Vector2(-1,-1):
		player.frame = 3
	#180
	elif input == Vector2(0,-1):
		player.frame = 4
	#225
	elif input == Vector2(1,-1):
		player.frame = 5
	#270ss
	elif input == Vector2(1,0):
		player.frame = 6
	#315
	elif input == Vector2(1,1):
		player.frame = 7
	
	
	

extends CharacterBody2D


var speed = 20000

var input = Vector2(0,0)
var position_cartesian = Vector2(0,0)


func _physics_process(delta):
	input.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	input.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	velocity = input.normalized()*speed*delta*Vector2(1,0.5)
	move_and_slide()

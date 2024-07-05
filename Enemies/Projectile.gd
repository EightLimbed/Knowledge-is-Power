extends CharacterBody2D

@export var damage : int = 10

var speed : int = 100
var rot : float
var spawn_pos : Vector2
var spawn_rot : float
var texture : Texture2D
var lifetime : float

# Called when the node enters the scene tree for the first time.
func _ready():
	$Lifetime.wait_time = lifetime
	global_position = spawn_pos
	$Sprite2D.texture = texture

func _process(delta):
	velocity = Vector2(speed,0).rotated(rot)*delta
	move_and_slide()

func _on_lifetime_timeout():
	queue_free()

func _on_area_2d_body_entered(_body):
	queue_free()

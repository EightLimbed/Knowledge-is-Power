extends CharacterBody2D

@export var damage : int = 10

var speed : int = 100
var direction : float
var spawn_rot : float
var texture : Texture2D
var lifetime : float
var piercing : float = 1

func _ready():
	$Lifetime.wait_time = lifetime
	rotation = direction + deg_to_rad(90)
	if texture:
		$Sprite2D.texture = texture

func _process(delta):
	velocity = Vector2(speed,0).rotated(direction)*delta
	move_and_slide()

func _on_lifetime_timeout():
	queue_free()

func _on_wall_detection_body_entered(_body):
	queue_free()

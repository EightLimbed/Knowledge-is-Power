extends CharacterBody2D

@export var damage : int = 10

var speed : int = 100
var direction : float
var spawn_rot : float
var texture : Texture2D
var lifetime : float
var pierce = 1

func _ready():
	$Lifetime.wait_time = lifetime
	$Lifetime.start()
	rotation = direction + deg_to_rad(90)
	if texture:
		$Sprite2D.texture = texture

func _process(delta):
	velocity = Vector2(speed,0).rotated(direction)*delta
	move_and_slide()
	if pierce <= 0:
		queue_free()

func _on_lifetime_timeout():
	queue_free()

func _on_wall_detection_body_entered(body):
	if body.name == "Dungeon":
		queue_free()
	if body.name == "EShield" and self.name.contains("PProj"):
		queue_free()
	if body.name == "PShield" and self.name.contains("EProj"):
		queue_free()

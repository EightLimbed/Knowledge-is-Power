extends CharacterBody2D

@export var damage : int = 10

var speed : int = 100
var rot : float
var spawn_rot : float
var texture : Texture2D
var lifetime : float
var piercing : float = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	$Lifetime.wait_time = lifetime
	rotation = rot + deg_to_rad(90)
	piercing += 1
	if texture:
		$Sprite2D.texture = texture

func _process(delta):
	$Deathtime.wait_time = delta*2
	velocity = Vector2(speed,0).rotated(rot)*delta
	move_and_slide()

func _on_lifetime_timeout():
	queue_free()

func _on_area_2d_body_entered(body):
	if body.name == "Dungeon":
		queue_free()

func _on_area_2d_area_entered(area):
	if area.name == "DamageHitbox":
		piercing -= 1
		if piercing <= 0:
			$Deathtime.start()

func _on_deathtime_timeout():
	queue_free()

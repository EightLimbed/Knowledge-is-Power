#blocks bullets
extends Node2D

var type = 2

@onready var grimoire = $Path2D/PathFollow2D/Texture
var path_offset : float
var path_prog : float
var speed : int = 150
@onready var shield = $Path2D/PathFollow2D/PShield
@onready var shield_hitbox = $Path2D/PathFollow2D/PShield/CollisionPolygon2D
@onready var path : PathFollow2D = $Path2D/PathFollow2D
@onready var player = get_tree().get_root().get_node("Game").get_node("Player")
@onready var input = player.get_node("Mobile")

func _process(delta):
	if input.shoot and player.mana >= 10*delta:
		grow_to(Vector2(1.8,1.8), 4, delta)
		player.mana -= 10*delta
	else:
		grow_to(Vector2(1,1), -4, delta)

	if round(scale) == Vector2(2,2):
		shield.visible = true
		shield_hitbox.disabled = false
	else:
		shield.visible = false
		shield_hitbox.disabled = true

	path_prog += speed * delta
	path.progress = path_prog+path_offset

func grow_to(size : Vector2, rate : int, delta : float):
	if abs(rate)/rate == 1:
		if not self.scale >= size:
			scale += Vector2(1,1)*delta*rate
			path.scale = Vector2(1,1)/scale
	else:
		if not self.scale <= size:
			scale += Vector2(1,1)*delta*rate
			path.scale = Vector2(1,1)/scale

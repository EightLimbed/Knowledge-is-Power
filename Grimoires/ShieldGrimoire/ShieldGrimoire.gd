#blocks bullets
extends Node2D

@onready var grimoire = $Path2D/PathFollow2D/Texture
var path_offset : float
var speed : int = 100
@onready var shield = $Path2D/PathFollow2D/PShield
@onready var path : PathFollow2D = $Path2D/PathFollow2D

func _process(delta):
	offset()
	if Input.is_action_pressed("Mouse"):
		grow_to(Vector2(3,3), 8, delta)
	else:
		grow_to(Vector2(1,1), -8, delta)

	if round(scale) == Vector2(3,3):
		shield.visible = true
		shield.disable_mode = true
	else:
		shield.visible = false
		shield.disable_mode = false

	path.progress += speed*delta

func offset():
	if path_offset > 0:
		path.progress += path_offset
		path_offset = 0

func grow_to(size : Vector2, rate : int, delta : float):
	if not round(self.scale) == size:
		scale += Vector2(1,1)*delta*rate
		path.scale = Vector2(1,1)/scale

#melee grimoire
extends Node2D

@onready var grimoire = $Path2D/PathFollow2D/Texture
var path_offset : float
@onready var damage : CharacterBody2D = $Path2D/PathFollow2D/PProj
var speed : int = 100
@onready var path : PathFollow2D = $Path2D/PathFollow2D

func _process(delta):
	offset()
	if Input.is_action_pressed("Mouse"):
		grow_to(Vector2(4,4), 8, delta)
		damage.damage = 20
	else:
		grow_to(Vector2(1,1), -8, delta)
		damage.damage = 0
	path.progress += speed*delta

func offset():
	if path_offset > 0:
		path.progress += path_offset
		path_offset = 0

func grow_to(size : Vector2, rate : int, delta : float):
	if not round(self.scale) == size:
		scale += Vector2(1,1)*delta*rate
		path.scale = Vector2(1,1)/scale

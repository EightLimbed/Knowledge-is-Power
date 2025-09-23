#melee grimoire
extends Node2D

var type = 1

@onready var shoot_detector = get_tree().get_root().get_node("Game").get_node("AimingCrosshair")

@onready var grimoire = $Path2D/PathFollow2D/Texture
var path_offset : float
var path_prog : float
@onready var damage : CharacterBody2D = $Path2D/PathFollow2D/PProj
var speed : int = 100
@onready var path : PathFollow2D = $Path2D/PathFollow2D
@onready var player = get_tree().get_root().get_node("Game").get_node("Player")

func _process(delta):
	if shoot_detector.pressed and player.mana >= 20:
		grow_to(Vector2(3,3), 8, delta)
		player.mana -= 20*delta
	else:
		grow_to(Vector2(1.5,1.5), -8, delta)
		damage.damage = 0

	if round(scale) == Vector2(3,3):
		damage.damage = 40
	else:
		damage.damage = 0

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

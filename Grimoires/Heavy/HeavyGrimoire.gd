#melee grimoire
extends Node2D

@onready var grimoire = $Path2D/PathFollow2D/Texture
var path_offset : int
@onready var damage : CharacterBody2D = $Path2D/PathFollow2D/PProj
var speed : int = 100
@onready var path : PathFollow2D = $Path2D/PathFollow2D
var projectile_texture = preload("res://Grimoires/Default/Art/DefaultGrimoireProjectile.png")

func _process(delta):
	offset()
	if Input.is_action_pressed("Mouse"):
		scale = Vector2(4,4)
		path.scale = Vector2(0.25,0.25)
		damage.damage = 20
	else:
		scale = Vector2(1,1)
		path.scale = Vector2(1,1)
		damage.damage = 0
	path.progress += speed*delta

func offset():
	if path_offset > 0:
		path.progress += path_offset
		path_offset = 0

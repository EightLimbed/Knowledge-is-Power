#need to offset attack speed also
extends Node2D

@onready var grimoire = $Path2D/PathFollow2D/Texture

var speed : int = 100
var path_offset : int
var attack_speed : float = 0.4
@onready var path : PathFollow2D = $Path2D/PathFollow2D
@onready var projectile_emitter = $ProjectileEmitter
var attack : float

var projectile_texture = preload("res://Grimoires/Default/Art/DefaultGrimoireProjectile.png")

func _process(delta):
	offset()
	if attack >= attack_speed:
		if Input.is_action_pressed("Mouse"):
			attack = 0
			#shoot(texture, spawn, target, multishot, spread, lifetime, speed, damage)
			projectile_emitter.shoot(projectile_texture, "PProj", grimoire.global_position - Vector2(0,28), get_global_mouse_position(), 1, 0, 1, 40000, 5)
	else:
		attack += delta
	path.progress += speed*delta

func offset():
	if path_offset > 0:
		path.progress += path_offset
		path_offset = 0

extends Node2D

@onready var grimoire = $Path2D/PathFollow2D/Texture

var speed : int = 100
@onready var path : PathFollow2D = $Path2D/PathFollow2D
@onready var projectile_emitter = $ProjectileEmitter
var attack : float = 0.25
var projectile_texture = preload("res://Grimoires/Default/Art/DefaultGrimoireProjectile.png")

func _process(delta):
	if attack >= 0.25:
		if Input.is_action_pressed("Mouse"):
			attack = 0
			#shoot(texture, spawn, target, multishot, spread, lifetime, speed, damage)
			projectile_emitter.shoot(projectile_texture, "PProj", grimoire.global_position - Vector2(0,24), get_global_mouse_position(), 3, 15, 1, 40000, 5)
	else:
		attack += delta
	path.progress += speed*delta

#need to offset attack speed also
extends Node2D

var type = 0

@onready var grimoire = $Path2D/PathFollow2D/Texture

var speed : int = 75
var path_offset : float
var attack_speed : float = 0.25
@onready var path : PathFollow2D = $Path2D/PathFollow2D
@onready var projectile_emitter = $ProjectileEmitter
@onready var player = get_tree().get_root().get_node("Game").get_node("Player")
var attack : float = 0

var projectile_texture = preload("res://Grimoires/DefaultGrimoire/Art/DefaultGrimoireProjectile.png")

func _process(delta):
	offset()
	if attack >= attack_speed:
		if Input.is_action_pressed("Mouse") and player.mana >= 25:
			player.mana -= 25
			attack = 0
			#shoot(texture, spawn, target, multishot, spread, lifetime, speed, damage)
			projectile_emitter.shoot(projectile_texture, "PProj", grimoire.global_position - Vector2(0,28), get_global_mouse_position(), 1, 0, 1, 40000, 7)
	else:
		attack += delta
	path.progress += speed*delta

func offset():
	if path_offset > 0:
		path.progress += path_offset
		path_offset = 0
